package service

import (
	"context"
	"database/sql"
	"fmt"
	"math"
	"time"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceCounter struct {
	db     *sql.DB
	dishes *ServiceDishes
}

func NewServiceCounter() *ServiceCounter {
	db := repo.GetDatabaseInstance().DB
	return &ServiceCounter{db: db, dishes: NewServiceDishes()}
}

func (s *ServiceCounter) Get(ctx context.Context, date time.Time, dishIDs []int, slotsRange []int, currentDietDay int, currentWeight float32) (*model.Menu, error) {
	// sprawdzamy, czy data istnieje w tabeli counter
	exists, err := s.IsDateInTable(ctx, date)
	if err != nil {
		return nil, err
	}
	if !exists {

		// jeśli nie istnieje to wykonujemy operacje kopiowania skłądników na ten dzień według tabeli diet_slots i dishes
		s.CopyToCounter(ctx, date, dishIDs) // tymczasowo puste dania
	}

	// jeśli istnieje to pobieramy składniki z tabeli counter
	menu, erctxr := s.GetMenuForDate(ctx, date, dishIDs, slotsRange, currentDietDay, currentWeight)
	if erctxr != nil {
		return nil, erctxr
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

func (s *ServiceCounter) GetMenuForDate(ctx context.Context, date time.Time, dishIDs []int, slotsRange []int, currentDietDay int, currentWeight float32) (*model.Menu, error) {
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
			Ingredient: *ingredient,
			Amount:     amount,
		}
		mealMap[meal] = append(mealMap[meal], ingInDish)
	}
	dishes := make([]*model.DishGet, 5)
	for i, dishID := range dishIDs {
		if dishID == 0 {
			dishes[i] = nil
			continue
		}
		dishTemp, err := NewServiceDishes().GetCounterByID(ctx, dishID)
		if err != nil {
			return nil, fmt.Errorf("fetch dish %d: %w", dishID, err)
		}
		switch i {
		case 0:
			dishTemp.Ingredients = mealMap["Breakfast"]
		case 1:
			dishTemp.Ingredients = mealMap["Lunch"]
		case 2:
			dishTemp.Ingredients = mealMap["Pre-Workout"]
		case 3:
			dishTemp.Ingredients = mealMap["Post-Workout"]
		case 4:
			dishTemp.Ingredients = mealMap["Supper"]
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
	menu, err = s.CalculateMenuSummary(ctx, menu, currentDietDay, currentWeight)
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
			sumKcal += round2(ing.Ingredient.Kcal * ing.Amount / ing.Ingredient.DefaultAmount)
			sumProt += round2(ing.Ingredient.Protein * ing.Amount / ing.Ingredient.DefaultAmount)
			sumCarb += round2(ing.Ingredient.Carbs * ing.Amount / ing.Ingredient.DefaultAmount)
			sumFats += round2(ing.Ingredient.Fat * ing.Amount / ing.Ingredient.DefaultAmount)
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
			sumKcal += round2(ing.Ingredient.Kcal * ing.Amount / ing.Ingredient.DefaultAmount)
			sumProt += round2(ing.Ingredient.Protein * ing.Amount / ing.Ingredient.DefaultAmount)
			sumCarb += round2(ing.Ingredient.Carbs * ing.Amount / ing.Ingredient.DefaultAmount)
			sumFats += round2(ing.Ingredient.Fat * ing.Amount / ing.Ingredient.DefaultAmount)
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
			sumKcal += round2(ing.Ingredient.Kcal * ing.Amount / ing.Ingredient.DefaultAmount)
			sumProt += round2(ing.Ingredient.Protein * ing.Amount / ing.Ingredient.DefaultAmount)
			sumCarb += round2(ing.Ingredient.Carbs * ing.Amount / ing.Ingredient.DefaultAmount)
			sumFats += round2(ing.Ingredient.Fat * ing.Amount / ing.Ingredient.DefaultAmount)
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
			sumKcal += round2(ing.Ingredient.Kcal * ing.Amount / ing.Ingredient.DefaultAmount)
			sumProt += round2(ing.Ingredient.Protein * ing.Amount / ing.Ingredient.DefaultAmount)
			sumCarb += round2(ing.Ingredient.Carbs * ing.Amount / ing.Ingredient.DefaultAmount)
			sumFats += round2(ing.Ingredient.Fat * ing.Amount / ing.Ingredient.DefaultAmount)
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
			sumKcal += round2(ing.Ingredient.Kcal * ing.Amount / ing.Ingredient.DefaultAmount)
			sumProt += round2(ing.Ingredient.Protein * ing.Amount / ing.Ingredient.DefaultAmount)
			sumCarb += round2(ing.Ingredient.Carbs * ing.Amount / ing.Ingredient.DefaultAmount)
			sumFats += round2(ing.Ingredient.Fat * ing.Amount / ing.Ingredient.DefaultAmount)
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
	currentDietDayInDayKcal := currentDietDay - int(math.Floor(float64(currentDietDay)/7))
	var dayKcalGoal float64
	err := s.db.QueryRowContext(ctx, `
		SELECT kcal
		FROM day_kcals
		WHERE day_num = $1
	`, currentDietDayInDayKcal).Scan(&dayKcalGoal)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch max dayGoal: %w", err)
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
