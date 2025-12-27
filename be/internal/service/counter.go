package service

import (
	"context"
	"database/sql"
	"fmt"
	"sort"
	"time"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
	"github.com/lib/pq"
)

type ServiceCounter struct {
	db     *sql.DB
	dishes *ServiceDishes
}

func NewServiceCounter() *ServiceCounter {
	db := repo.GetDatabaseInstance().DB
	return &ServiceCounter{db: db, dishes: NewServiceDishes()}
}

func (s *ServiceCounter) Get(ctx context.Context, dietContext *model.DietContext, date time.Time, dishIDs []int, slotsRange []int, currentDietDay int) (*model.Menu, error) {
	// sprawdzamy, czy data istnieje w tabeli counter
	exists, err := s.IsDateInTable(ctx, date)
	if err != nil {
		return nil, err
	}
	if !exists {
		// jeśli nie istnieje to wykonujemy operacje kopiowania skłądników na ten dzień według tabeli diet_slots i dishes
		s.CopyToCounter(ctx, date, dishIDs)
		s.CopyToDietSlotsCounter(ctx, dietContext, date, slotsRange)
	}
	// dishIds trzeba podmienić teraz na te z tabeli diet_slots_counter
	newDishIDs, err := s.GetDishIDsFromDietSlotsCounter(ctx, date)
	if err != nil {
		return nil, err
	}

	// pobieramy składniki z tabeli counter (jeśli dania tam nie było to poprzedni if go dodał)
	menu, err := s.GetMenuForDate(ctx, date, newDishIDs, slotsRange, currentDietDay, *dietContext)
	if err != nil {
		return nil, err
	}
	// przy okazji robimy TableCleanup dla counter
	_, err = s.DeleteOldCounterRecords(ctx, 7)
	if err != nil {
		return nil, err
	}
	// zwracamy menu
	return menu, nil
}

func (s *ServiceCounter) IsDateInTable(ctx context.Context, date time.Time) (bool, error) {
	var exists bool
	err := s.db.QueryRowContext(ctx, `
		SELECT EXISTS (
			SELECT 1
			FROM counter
			WHERE day = $1)
	`, date).Scan(&exists)
	if err != nil {
		return false, err
	}
	return exists, nil
}

func (s *ServiceCounter) RemoveDateFromTable(ctx context.Context, date time.Time) error {
	_, err := s.db.ExecContext(ctx, `
		DELETE FROM counter
		WHERE day = $1
	`, date)
	if err != nil {
		return err
	}
	return nil
}

// This method copies the menu for the given day (usually current) to the counter table.
func (s *ServiceCounter) CopyToCounter(ctx context.Context, date time.Time, dishIDs []int) error {
	// odtworzenie dań z diet_slots
	var dishes [5]*model.DishGet
	for i, id := range dishIDs {
		var dish *model.DishGet
		if id == 0 {
			dish = nil
			continue
		}
		dish, err := s.dishes.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("fetch dish %d: %w", id, err)
		}
		dishes[i] = dish
	}
	mealSlotsStr := [5]string{"Breakfast", "Lunch", "Pre-Workout", "Post-Workout", "Supper"}
	for i, dish := range dishes {
		if dish == nil {
			continue
		} else {
			err := s.AddIngredientsToCounter(ctx, date, mealSlotsStr[i], dish.Ingredients)
			if err != nil {
				return fmt.Errorf("adding ingredients to counter: %w", err)
			}
		}
	}

	return nil
}

func (s *ServiceCounter) AddIngredientsToCounter(ctx context.Context, date time.Time, mealSlot string, ingredients []model.IngredientInDishGet) error {
	// Otwórz transakcję, by wszystkie inserty były atomowe
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("begin tx: %w", err)
	}
	defer func() {
		if err != nil {
			_ = tx.Rollback()
		}
	}()

	// Przygotuj zapytanie
	stmt, err := tx.PrepareContext(ctx, `
		INSERT INTO counter (day, ingredient_id, meal, amount)
		VALUES ($1, $2, $3, $4)
		ON CONFLICT (day, ingredient_id, meal)
		DO UPDATE SET amount = EXCLUDED.amount
	`)
	if err != nil {
		return fmt.Errorf("prepare stmt: %w", err)
	}
	defer stmt.Close()

	// Iteracja po liście składników
	for _, ing := range ingredients {
		_, err := stmt.ExecContext(ctx,
			date,
			ing.Ingredient.ID,
			mealSlot,
			ing.Amount,
		)
		if err != nil {
			return fmt.Errorf("insert ingredient %d: %w", ing.Ingredient.ID, err)
		}
	}

	// Zatwierdź transakcję
	if err := tx.Commit(); err != nil {
		return fmt.Errorf("commit: %w", err)
	}

	return nil
}

func (s *ServiceCounter) GetMenuForDate(ctx context.Context, date time.Time, dishIDs []*int, slotsRange []int, currentDietDay int, dietContext model.DietContext) (*model.Menu, error) {
	// Pobierz składniki z tabeli counter dla danego dnia
	rows, err := s.db.QueryContext(ctx, `
		SELECT meal, ingredient_id, amount
		FROM counter
		WHERE day = $1
	`, date)
	if err != nil {
		return nil, fmt.Errorf("query counter: %w", err)
	}
	defer rows.Close()
	// Mapa: meal → []IngredientInDishGet
	mealMap := make(map[string][]model.IngredientInDishGet)
	for rows.Next() {
		var meal string
		var ingredientID int
		var amount float64
		if err := rows.Scan(&meal, &ingredientID, &amount); err != nil {
			return nil, fmt.Errorf("scan row: %w", err)
		}
		ingredient, err := NewServiceIngredients().GetByID(ctx, ingredientID)
		if err != nil {
			return nil, fmt.Errorf("fetch ingredient %d: %w", ingredientID, err)
		}
		ingInDish := model.IngredientInDishGet{
			Ingredient: model.IngredientGetPut{
				ID:            ingredient.ID,
				Name:          ingredient.Name,
				Kcal:          ingredient.Kcal * amount / ingredient.DefaultAmount,
				Protein:       ingredient.Protein * amount / ingredient.DefaultAmount,
				Carbs:         ingredient.Carbs * amount / ingredient.DefaultAmount,
				Fat:           ingredient.Fat * amount / ingredient.DefaultAmount,
				DefaultAmount: ingredient.DefaultAmount,
				Unit:          ingredient.Unit,
				Labels:        ingredient.Labels,
				Path:          ingredient.Path,
			},
			Amount: amount,
		}
		mealMap[meal] = append(mealMap[meal], ingInDish)
	}
	dishes := make([]*model.DishGet, 5)
	for i, dishID := range dishIDs {
		dishTemp, err := NewServiceDishes().GetCounterByID(ctx, dishID)
		if err != nil {
			return nil, fmt.Errorf("fetch dish %d: %w", dishID, err)
		}
		switch i {
		case 0:
			dishTemp.Ingredients = mealMap["Breakfast"]
			name, err := s.GetRecordNameFromDietSlotsCounter(ctx, dietContext.ActiveDietID, date.Format("2006-01-02"), "Breakfast")
			if err != nil {
				return nil, fmt.Errorf("fetch record name: %w", err)
			}
			dishTemp.Name = name
			dishTemp.Meal = "Breakfast"
		case 1:
			dishTemp.Ingredients = mealMap["Lunch"]
			name, err := s.GetRecordNameFromDietSlotsCounter(ctx, dietContext.ActiveDietID, date.Format("2006-01-02"), "Lunch")
			if err != nil {
				return nil, fmt.Errorf("fetch record name: %w", err)
			}
			dishTemp.Name = name
			dishTemp.Meal = "MainMeal"
		case 2:
			dishTemp.Ingredients = mealMap["Pre-Workout"]
			name, err := s.GetRecordNameFromDietSlotsCounter(ctx, dietContext.ActiveDietID, date.Format("2006-01-02"), "Pre-Workout")
			if err != nil {
				return nil, fmt.Errorf("fetch record name: %w", err)
			}
			dishTemp.Name = name
			dishTemp.Meal = "Pre-Workout"
		case 3:
			dishTemp.Ingredients = mealMap["Post-Workout"]
			name, err := s.GetRecordNameFromDietSlotsCounter(ctx, dietContext.ActiveDietID, date.Format("2006-01-02"), "Post-Workout")
			if err != nil {
				return nil, fmt.Errorf("fetch record name: %w", err)
			}
			dishTemp.Name = name
			dishTemp.Meal = "MainMeal"
		case 4:
			dishTemp.Ingredients = mealMap["Supper"]
			name, err := s.GetRecordNameFromDietSlotsCounter(ctx, dietContext.ActiveDietID, date.Format("2006-01-02"), "Supper")
			if err != nil {
				return nil, fmt.Errorf("fetch record name: %w", err)
			}
			dishTemp.Name = name
			dishTemp.Meal = "Supper"
		}
		// posotruj składaniki według znaczenia kalorycznego
		if len(dishTemp.Ingredients) > 1 {
			sort.Slice(dishTemp.Ingredients, func(i, j int) bool {
				iKcal := dishTemp.Ingredients[i].Ingredient.Kcal
				jKcal := dishTemp.Ingredients[j].Ingredient.Kcal
				return iKcal > jKcal
			})
		}
		dishes[i] = dishTemp
	}
	// Teraz zbuduj strukturę Menu z pobranymi danymi
	menu := &model.Menu{
		Breakfast:   model.DishInMenu{Dish: dishes[0], SlotNum: slotsRange[0]},
		Lunch:       model.DishInMenu{Dish: dishes[1], SlotNum: slotsRange[1]},
		PreWorkout:  model.DishInMenu{Dish: dishes[2], SlotNum: slotsRange[2]},
		PostWorkout: model.DishInMenu{Dish: dishes[3], SlotNum: slotsRange[3]},
		Supper:      model.DishInMenu{Dish: dishes[4], SlotNum: slotsRange[4]},
		Summary:     model.MenuSummary{}, // Możesz dodać podsumowanie, jeśli potrzebne
	}

	//Policz Summary z ingredients
	menu, err = s.CalculateDishesSummary(menu)
	if err != nil {
		return nil, fmt.Errorf("calculate dishes summary: %w", err)
	}
	menu, err = s.CalculateMenuSummary(ctx, menu, currentDietDay, float32(dietContext.CurrentWeight))
	if err != nil {
		return nil, fmt.Errorf("calculate menu summary: %w", err)
	}
	return menu, nil
}

func (s *ServiceCounter) CalculateDishesSummary(menu *model.Menu) (*model.Menu, error) {
	sumKcal := 0.0
	sumProt := 0.0
	sumCarb := 0.0
	sumFats := 0.0
	if menu.Breakfast.Dish != nil {
		for _, ing := range menu.Breakfast.Dish.Ingredients {
			sumKcal += ing.Ingredient.Kcal
			sumProt += ing.Ingredient.Protein
			sumCarb += ing.Ingredient.Carbs
			sumFats += ing.Ingredient.Fat
		}
		menu.Breakfast.Dish.Kcal = round2(sumKcal)
		menu.Breakfast.Dish.Protein = round2(sumProt)
		menu.Breakfast.Dish.Carbs = round2(sumCarb)
		menu.Breakfast.Dish.Fat = round2(sumFats)
	}
	sumKcal = 0.0
	sumProt = 0.0
	sumCarb = 0.0
	sumFats = 0.0
	if menu.Lunch.Dish != nil {
		for _, ing := range menu.Lunch.Dish.Ingredients {
			sumKcal += ing.Ingredient.Kcal
			sumProt += ing.Ingredient.Protein
			sumCarb += ing.Ingredient.Carbs
			sumFats += ing.Ingredient.Fat
		}
		menu.Lunch.Dish.Kcal = round2(sumKcal)
		menu.Lunch.Dish.Protein = round2(sumProt)
		menu.Lunch.Dish.Carbs = round2(sumCarb)
		menu.Lunch.Dish.Fat = round2(sumFats)
	}
	sumKcal = 0.0
	sumProt = 0.0
	sumCarb = 0.0
	sumFats = 0.0
	if menu.PreWorkout.Dish != nil {
		for _, ing := range menu.PreWorkout.Dish.Ingredients {
			sumKcal += ing.Ingredient.Kcal
			sumProt += ing.Ingredient.Protein
			sumCarb += ing.Ingredient.Carbs
			sumFats += ing.Ingredient.Fat
		}
		menu.PreWorkout.Dish.Kcal = round2(sumKcal)
		menu.PreWorkout.Dish.Protein = round2(sumProt)
		menu.PreWorkout.Dish.Carbs = round2(sumCarb)
		menu.PreWorkout.Dish.Fat = round2(sumFats)
	}
	sumKcal = 0.0
	sumProt = 0.0
	sumCarb = 0.0
	sumFats = 0.0
	if menu.PostWorkout.Dish != nil {
		for _, ing := range menu.PostWorkout.Dish.Ingredients {
			sumKcal += ing.Ingredient.Kcal
			sumProt += ing.Ingredient.Protein
			sumCarb += ing.Ingredient.Carbs
			sumFats += ing.Ingredient.Fat
		}
		menu.PostWorkout.Dish.Kcal = round2(sumKcal)
		menu.PostWorkout.Dish.Protein = round2(sumProt)
		menu.PostWorkout.Dish.Carbs = round2(sumCarb)
		menu.PostWorkout.Dish.Fat = round2(sumFats)
	}
	sumKcal = 0.0
	sumProt = 0.0
	sumCarb = 0.0
	sumFats = 0.0
	if menu.Supper.Dish != nil {
		for _, ing := range menu.Supper.Dish.Ingredients {
			sumKcal += ing.Ingredient.Kcal
			sumProt += ing.Ingredient.Protein
			sumCarb += ing.Ingredient.Carbs
			sumFats += ing.Ingredient.Fat
		}
		menu.Supper.Dish.Kcal = round2(sumKcal)
		menu.Supper.Dish.Protein = round2(sumProt)
		menu.Supper.Dish.Carbs = round2(sumCarb)
		menu.Supper.Dish.Fat = round2(sumFats)
	}

	return menu, nil
}

func (s *ServiceCounter) CalculateMenuSummary(ctx context.Context, menu *model.Menu, currentDietDay int, currentWeight float32) (*model.Menu, error) {
	totalKcal := 0.0
	totalProteins := 0.0
	totalFats := 0.0
	totalCarbs := 0.0

	meals := []*model.DishInMenu{&menu.Breakfast, &menu.Lunch, &menu.PreWorkout, &menu.PostWorkout, &menu.Supper}
	for _, meal := range meals {
		if meal.Dish != nil {
			totalKcal += meal.Dish.Kcal
			totalProteins += meal.Dish.Protein
			totalFats += meal.Dish.Fat
			totalCarbs += meal.Dish.Carbs
		}
	}
	menu.Summary.Kcal = round2(totalKcal)
	menu.Summary.Proteins = round2(totalProteins)
	menu.Summary.Fats = round2(totalFats)
	menu.Summary.Carbs = round2(totalCarbs)
	// fetch kcal goal
	dietContext, err := repo.NewRepositoryDietContext().Get()
	if err != nil {
		return nil, fmt.Errorf("get active diet id: %w", err)
	}
	dayKcalGoal, err := repo.NewRepositoryDayKcals().GetKcalByDietIdAndDayNum(dietContext.ActiveDietID, currentDietDay)
	if err != nil {
		return nil, fmt.Errorf("get day kcal goal: %w", err)
	}
	menu.Summary.KcalGoal = round2(dayKcalGoal)
	menu.Summary.ProteinPerKg = round2(totalProteins / float64(currentWeight))
	fatsPerc := 0.0
	if totalKcal > 0 {
		fatsPerc = round2(totalFats * 9 / totalKcal * 100)
	}
	menu.Summary.FatsPerc = fatsPerc
	menu.Summary.CarbsPerKg = round2(totalCarbs / float64(currentWeight))

	return menu, nil
}

func (s *ServiceCounter) UpsertCounterRecord(ctx context.Context, r model.UpsertCounterRecord) error {
	// 1️⃣ Jeżeli składnik się zmienił — usuń stary rekord
	if r.OldIngredientId != nil && *r.OldIngredientId != r.IngredientId {
		_, err := s.db.ExecContext(ctx, `
			DELETE FROM counter
			WHERE day = $1 AND meal = $2 AND ingredient_id = $3;
		`, r.Day, r.Meal, *r.OldIngredientId)
		if err != nil {
			return fmt.Errorf("delete old counter record: %w", err)
		}
	}

	// 2️⃣ Następnie wstaw/aktualizuj nowy rekord
	_, err := s.db.ExecContext(ctx, `
        INSERT INTO counter (day, ingredient_id, meal, amount)
        VALUES ($1, $2, $3, $4)
        ON CONFLICT (day, ingredient_id, meal)
        DO UPDATE SET amount = EXCLUDED.amount;
    `, r.Day, r.IngredientId, r.Meal, r.Amount)
	if err != nil {
		return fmt.Errorf("upsert counter record: %w", err)
	}

	return nil
}

func (s *ServiceCounter) DeleteCounterRecord(ctx context.Context, r model.CounterRecordIndex) error {
	_, err := s.db.ExecContext(ctx, `
		DELETE FROM counter
		WHERE day = $1 AND ingredient_id = $2 AND meal = $3
	`, r.Day, r.IngredientId, r.Meal)
	return err
}

func (s *ServiceCounter) DeleteOldCounterRecords(ctx context.Context, deltaDays int) (int64, error) {
	query := `
		DELETE FROM counter
		WHERE day < (CURRENT_DATE - INTERVAL '%d days')
	`
	// interpolacja deltaDays do zapytania
	q := fmt.Sprintf(query, deltaDays)

	result, err := s.db.ExecContext(ctx, q)
	if err != nil {
		return 0, fmt.Errorf("delete old counter records: %w", err)
	}

	rows, _ := result.RowsAffected()
	return rows, nil
}

var slotToMeal = []string{
	"Breakfast",
	"Lunch",
	"Pre-Workout",
	"Post-Workout",
	"Supper",
}

func (s *ServiceCounter) CopyToDietSlotsCounter(
	ctx context.Context,
	dietContext *model.DietContext,
	date time.Time,
	slotsRange []int,
) error {

	// -----------------------------
	// 1. Pobierz sloty
	// -----------------------------
	rows, err := s.db.QueryContext(ctx, `
		SELECT diet_id, slot_num, dish_id
		FROM diet_slots
		WHERE diet_id = $1
		  AND slot_num = ANY($2)
		  AND dish_id IS NOT NULL
	`, dietContext.ActiveDietID, pq.Array(slotsRange))
	if err != nil {
		return fmt.Errorf("query diet_slots: %w", err)
	}
	defer rows.Close()

	type slotRow struct {
		SlotNum int
		DishID  int
	}

	var slots []slotRow

	for rows.Next() {
		var r slotRow
		if err := rows.Scan(new(int), &r.SlotNum, &r.DishID); err != nil {
			return fmt.Errorf("scan slot: %w", err)
		}
		slots = append(slots, r)
	}
	if err := rows.Err(); err != nil {
		return err
	}

	if len(slots) != 5 {
		return fmt.Errorf("expected 5 slots, got %d", len(slots))
	}

	// -----------------------------
	// 2. Przygotuj dane do INSERT
	// -----------------------------
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	stmt, err := tx.PrepareContext(ctx, `
		INSERT INTO diet_slots_counter (
			diet_id, day, meal, name, dish_id
		) VALUES ($1, $2, $3, $4, $5)
		ON CONFLICT (diet_id, day, meal) DO UPDATE
		SET name = EXCLUDED.name,
		    dish_id = EXCLUDED.dish_id
	`)
	if err != nil {
		return err
	}
	defer stmt.Close()

	dishesSvc := NewServiceDishes()

	for _, s := range slots {
		meal := slotToMeal[s.SlotNum%5]

		name, err := dishesSvc.GetNameById(ctx, s.DishID)
		if err != nil {
			return fmt.Errorf("dish %d: %w", s.DishID, err)
		}

		if _, err := stmt.ExecContext(
			ctx,
			dietContext.ActiveDietID,
			date,
			meal,
			name,
			s.DishID,
		); err != nil {
			return fmt.Errorf("insert meal %s: %w", meal, err)
		}
	}

	// -----------------------------
	// 3. Commit
	// -----------------------------
	return tx.Commit()
}

func (s *ServiceCounter) UpsertDietSlotsCounterRecord(
	ctx context.Context,
	record model.UpsertDietSlotsCounterRecord,
) error {

	dietContext, err := NewServiceDietContext().Get(ctx)
	if err != nil {
		return fmt.Errorf("get diet context: %w", err)
	}
	dietID := dietContext.ActiveDiet.ID

	// -----------------------------
	// 1. Pobierz aktualny rekord
	// -----------------------------
	var currentDishID *int64
	var currentName *string

	err = s.db.QueryRowContext(ctx, `
		SELECT dish_id, name
		FROM diet_slots_counter
		WHERE diet_id = $1 AND day = $2 AND meal = $3
	`,
		dietID,
		record.Day,
		record.Meal,
	).Scan(&currentDishID, &currentName)

	if err != nil && err != sql.ErrNoRows {
		return fmt.Errorf("query current slot: %w", err)
	}

	// -----------------------------
	// 2. Sprawdź czy zmienił się dishId
	// -----------------------------
	dishChanged := false

	if record.DishID != nil {
		if currentDishID == nil || *record.DishID != *currentDishID {
			dishChanged = true
		}
	}

	// -----------------------------
	// 3. TRANSAKCJA
	// -----------------------------
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// -----------------------------
	// 4. Jeśli dishId się ZMIENIŁ
	// -----------------------------
	if dishChanged {
		// Replace ingredients counter for slot
		err := s.ReplaceIngredientsForSlotWithDish(
			ctx,
			record.Day,
			record.Meal,
			record.DishID,
		)
		if err != nil {
			return err
		}
	}

	// -----------------------------
	// 5. UPSERT slot (name + dishId)
	// -----------------------------
	_, err = tx.ExecContext(ctx, `
		INSERT INTO diet_slots_counter (diet_id, day, meal, name, dish_id)
		VALUES ($1, $2, $3, $4, $5)
		ON CONFLICT (diet_id, day, meal)
		DO UPDATE SET
			name    = COALESCE(EXCLUDED.name, diet_slots_counter.name),
			dish_id = COALESCE(EXCLUDED.dish_id, diet_slots_counter.dish_id)
	`,
		dietID,
		record.Day,
		record.Meal,
		record.Name,
		record.DishID,
	)
	if err != nil {
		return fmt.Errorf("upsert slot counter: %w", err)
	}

	// -----------------------------
	// 6. COMMIT
	// -----------------------------
	return tx.Commit()
}

func (s *ServiceCounter) ReplaceIngredientsForSlotWithDish(
	ctx context.Context,
	day string,
	meal string,
	newDishID *int64,
) error {

	// 1. Parse day
	dayTime, err := time.Parse("2006-01-02", day)
	if err != nil {
		return fmt.Errorf("invalid day format %q: %w", day, err)
	}

	// 2. Erase existing ingredients for slot
	_, err = s.db.ExecContext(ctx, `
		DELETE FROM counter
		WHERE day = $1 AND meal = $2
	`, dayTime, meal)
	if err != nil {
		return fmt.Errorf("delete existing ingredients for slot: %w", err)
	}

	// 3. No dish assigned → nothing more to do
	if newDishID == nil {
		return nil
	}

	// 4. Fetch dish
	dish, err := s.dishes.GetByID(ctx, int(*newDishID))
	if err != nil {
		return fmt.Errorf("fetch dish %d: %w", *newDishID, err)
	}

	// 5. Add ingredients to counter
	if err := s.AddIngredientsToCounter(ctx, dayTime, meal, dish.Ingredients); err != nil {
		return fmt.Errorf("add ingredients to counter: %w", err)
	}

	return nil
}

func (s *ServiceCounter) GetDishIDsFromDietSlotsCounter(ctx context.Context, date time.Time) ([]*int, error) {
	// Pobierz dish_id z tabeli diet_slots_counter dla danego dnia
	rows, err := s.db.QueryContext(ctx, `
		SELECT meal, dish_id
		FROM diet_slots_counter
		WHERE day = $1
	`, date)
	if err != nil {
		return nil, fmt.Errorf("query diet_slots_counter: %w", err)
	}
	defer rows.Close()

	dishIDs := make([]*int, 5) // Zakładamy 5 slotów

	for rows.Next() {
		var meal string
		var dishID *int
		if err := rows.Scan(&meal, &dishID); err != nil {
			return nil, fmt.Errorf("scan row: %w", err)
		}
		switch meal {
		case "Breakfast":
			dishIDs[0] = dishID
		case "Lunch":
			dishIDs[1] = dishID
		case "Pre-Workout":
			dishIDs[2] = dishID
		case "Post-Workout":
			dishIDs[3] = dishID
		case "Supper":
			dishIDs[4] = dishID
		}
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return dishIDs, nil
}

func (s *ServiceCounter) GetRecordNameFromDietSlotsCounter(
	ctx context.Context,
	dietID int,
	day string,
	meal string,
) (string, error) {
	var name *string
	err := s.db.QueryRowContext(ctx, `
		SELECT name
		FROM diet_slots_counter
		WHERE diet_id = $1 AND day = $2 AND meal = $3
	`, dietID, day, meal).Scan(&name)
	if err != nil {
		return "", nil
	}
	// if name is nil, return empty string
	if name == nil {
		return "", nil
	}
	return *name, nil
}

func (s *ServiceCounter) DeleteDietSlotsCounterRecord(
	ctx context.Context,
	record model.DietSlotsCounterRecordIndex,
) error {
	// set dish_id and name to NULL
	_, err := s.db.ExecContext(ctx, `
		UPDATE diet_slots_counter
		SET dish_id = NULL,
		    name = NULL
		WHERE day = $1 AND meal = $2
	`, record.Day, record.Meal)
	// delete all records from counter table for that day and meal
	_, err = s.db.ExecContext(ctx, `
		DELETE FROM counter
		WHERE day = $1 AND meal = $2
	`, record.Day, record.Meal)
	return err
}

func (s *ServiceCounter) CopyDietSlotsCounterRecords(
	ctx context.Context,
	record model.CopyDietSlotsCounterRecords,
) error {
	fmt.Println(record)
	// --- anti self-copy guard ---
	if record.From.Day == record.To.Day && record.From.Meal == record.To.Meal {
		return fmt.Errorf(
			"copy rejected: source and destination slot are identical (day=%s, meal=%s)",
			record.From.Day,
			record.From.Meal,
		)
	}

	// Fetch diet context
	dietContext, err := NewServiceDietContext().Get(ctx)
	if err != nil {
		return fmt.Errorf("get diet context: %w", err)
	}
	dietID := dietContext.ActiveDiet.ID

	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("begin tx: %w", err)
	}

	// Safety rollback (no-op if committed)
	defer func() {
		_ = tx.Rollback()
	}()

	// --- diet_slots_counter ---
	_, err = tx.ExecContext(ctx, `
		INSERT INTO diet_slots_counter (diet_id, day, meal, name, dish_id)
		SELECT diet_id, $1, $2, name, dish_id
		FROM diet_slots_counter
		WHERE diet_id = $3 AND day = $4 AND meal = $5
		ON CONFLICT (diet_id, day, meal) DO UPDATE
		SET name = EXCLUDED.name,
		    dish_id = EXCLUDED.dish_id
	`,
		record.To.Day,
		record.To.Meal,
		dietID,
		record.From.Day,
		record.From.Meal,
	)
	if err != nil {
		return fmt.Errorf("copy diet_slots_counter: %w", err)
	}

	// --- counter: delete target ---
	_, err = tx.ExecContext(ctx, `
		DELETE FROM counter
		WHERE day = $1 AND meal = $2
	`,
		record.To.Day,
		record.To.Meal,
	)
	if err != nil {
		return fmt.Errorf("delete counter records: %w", err)
	}

	// --- counter: insert copy ---
	_, err = tx.ExecContext(ctx, `
		INSERT INTO counter (day, ingredient_id, meal, amount)
		SELECT $1, ingredient_id, $2, amount
		FROM counter
		WHERE day = $3 AND meal = $4
	`,
		record.To.Day,
		record.To.Meal,
		record.From.Day,
		record.From.Meal,
	)
	if err != nil {
		return fmt.Errorf("copy counter records: %w", err)
	}

	// --- commit ---
	if err := tx.Commit(); err != nil {
		return fmt.Errorf("commit tx: %w", err)
	}

	return nil
}
