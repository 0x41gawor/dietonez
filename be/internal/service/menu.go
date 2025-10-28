package service

import (
	"context"
	"database/sql"
	"fmt"
	"math"
	"time"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
	"github.com/lib/pq"
)

type ServiceMenu struct {
	db     *sql.DB
	dishes *ServiceDishes
}

func NewServiceMenu() *ServiceMenu {
	db := repo.GetDatabaseInstance().DB
	return &ServiceMenu{db: db, dishes: NewServiceDishes()}
}

func (s *ServiceMenu) Get(ctx context.Context, date time.Time) (*model.Menu, error) {
	var activeDietID int
	var startDate time.Time
	var currentWeight float64

	err := s.db.QueryRowContext(ctx, `
		SELECT active_diet, start_date, current_weight
		FROM diet_context
		LIMIT 1
	`).Scan(&activeDietID, &startDate, &currentWeight)

	// Walidacja: startDate musi być poniedziałkiem
	if startDate.Weekday() != time.Monday {
		return nil, fmt.Errorf("invalid start_date: expected Monday, got %s", startDate.Weekday().String())
	}

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("no active diet set in context")
		}
		return nil, fmt.Errorf("failed to fetch active diet: %w", err)
	}
	var maxSlotNum int
	err = s.db.QueryRowContext(ctx, `
		SELECT MAX(slot_num)
		FROM diet_slots
		WHERE diet_id = $1
	`, activeDietID).Scan(&maxSlotNum)

	if err != nil {
		return nil, fmt.Errorf("failed to fetch max slot_num: %w", err)
	}

	print("maxSlotNum:", maxSlotNum, "\n")

	// Obliczenie różnicy dni (startDate → date) +1
	daysBetween := int(date.Sub(startDate).Hours() / 24)
	print("daysBetween:", daysBetween, "\n")
	if daysBetween < 0 {
		return nil, fmt.Errorf("current date is before start date")
	}

	maxDietDay := (maxSlotNum + 1) / 5
	print("maxDietDay:", maxDietDay, "\n")
	currentDietDay := daysBetween % maxDietDay
	print("currentDietDay:", currentDietDay, "\n")

	slotsRange := getMenuSlotsRange(currentDietDay)
	fmt.Println(slotsRange)

	dishIDs, err := s.getDishIDsForSlots(ctx, activeDietID, slotsRange)
	if err != nil {
		return nil, err
	}

	var dishes [5]*model.DishGet
	for i, id := range dishIDs {
		var dish *model.DishGet
		if id == 0 {
			dish = nil
			continue
		}
		dish, err := s.dishes.GetByID(ctx, id)
		if err != nil {
			return nil, fmt.Errorf("fetch dish %d: %w", id, err)
		}
		dishes[i] = dish
	}

	// Liczenie summary danego dnia
	sumKcal := 0.0
	sumProtein := 0.0
	sumCarbs := 0.0
	sumFat := 0.0

	for _, dish := range dishes {
		if dish == nil {
			continue // pomijamy puste dania
		}
		// count sums
		sumKcal += round2(dish.Kcal)
		sumProtein += round2(dish.Protein)
		sumCarbs += round2(dish.Carbs)
		sumFat += round2(dish.Fat)
	}
	currentDietDayInDayKcal := currentDietDay - int(math.Floor(float64(currentDietDay)/7))
	// fetch kcal goal
	var dayKcalGoal float64
	err = s.db.QueryRowContext(ctx, `
		SELECT kcal
		FROM day_kcals
		WHERE day_num = $1
	`, currentDietDayInDayKcal).Scan(&dayKcalGoal)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch max dayGoal: %w", err)
	}
	// prepare summary
	fatsPerc := 0.0
	if sumKcal > 0 {
		fatsPerc = round2(sumFat * 9 / sumKcal * 100)
	}
	summary := model.MenuSummary{
		Kcal:         round2(sumKcal),
		Proteins:     round2(sumProtein),
		Fats:         round2(sumFat),
		Carbs:        round2(sumCarbs),
		KcalGoal:     round2(dayKcalGoal),
		ProteinPerKg: round2(sumProtein / currentWeight),
		FatsPerc:     fatsPerc,
		CarbsPerKg:   round2(sumCarbs / currentWeight),
	}

	menu := &model.Menu{
		Breakfast:   model.DishInMenu{Dish: dishes[0], SlotNum: slotsRange[0]},
		Lunch:       model.DishInMenu{Dish: dishes[1], SlotNum: slotsRange[1]},
		PreWorkout:  model.DishInMenu{Dish: dishes[2], SlotNum: slotsRange[2]},
		PostWorkout: model.DishInMenu{Dish: dishes[3], SlotNum: slotsRange[3]},
		Supper:      model.DishInMenu{Dish: dishes[4], SlotNum: slotsRange[4]},
		Summary:     summary,
	}

	return menu, nil
}

func getMenuSlotsRange(currentDietDay int) []int {
	start := currentDietDay * 5
	return []int{start, start + 1, start + 2, start + 3, start + 4}
}

func (s *ServiceMenu) getDishIDsForSlots(ctx context.Context, dietID int, slots []int) ([]int, error) {
	const q = `
		SELECT slot_num, dish_id
		FROM diet_slots
		WHERE diet_id = $1
  		AND slot_num = ANY($2)
  		AND dish_id IS NOT NULL
	`

	rows, err := s.db.QueryContext(ctx, q, dietID, pq.Array(slots))
	if err != nil {
		return nil, fmt.Errorf("query diet_slots: %w", err)
	}
	defer rows.Close()

	// Mapa: slot_num → dish_id
	slotMap := make(map[int]int)
	for rows.Next() {
		var slotNum, dishID int
		if err := rows.Scan(&slotNum, &dishID); err != nil {
			return nil, err
		}
		slotMap[slotNum] = dishID
	}

	// zachowaj kolejność jak w slotsRange
	dishIDs := make([]int, 0, len(slots))
	for _, slot := range slots {
		if dishID, ok := slotMap[slot]; ok {
			dishIDs = append(dishIDs, dishID)
		} else {
			dishIDs = append(dishIDs, 0) // lub panic/fallback
		}
	}
	print("dishIDs: ")
	for _, id := range dishIDs {
		print(id, " ")
	}
	print("\n")
	return dishIDs, nil
}

// This method copies the menu for the given day (usually current) to the counter table.
func (s *ServiceMenu) CopyToCounter(ctx context.Context, date time.Time, dishIDs []int) error {
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

func (s *ServiceMenu) AddIngredientsToCounter(ctx context.Context, date time.Time, mealSlot string, ingredients []model.IngredientInDishGet) error {
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
