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

	if date.Weekday() == time.Sunday {
		return &model.Menu{
			Breakfast:   model.DishInMenu{Dish: nil, SlotNum: nil},
			Lunch:       model.DishInMenu{Dish: nil, SlotNum: nil},
			PreWorkout:  model.DishInMenu{Dish: nil, SlotNum: nil},
			PostWorkout: model.DishInMenu{Dish: nil, SlotNum: nil},
			Supper:      model.DishInMenu{Dish: nil, SlotNum: nil},
			Summary:     model.MenuSummary{},
		}, nil
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

	// Obliczenie różnicy dni (startDate → date) +1
	daysBetween := int(date.Sub(startDate).Hours()/24) + 1
	if daysBetween <= 0 {
		return nil, fmt.Errorf("current date is before start date")
	}

	maxDietDay := maxSlotNum / 30 * 7
	currentDietDay := daysBetween % maxDietDay

	fmt.Println(currentDietDay)

	slotsRange := getMenuSlotsRange(currentDietDay)
	fmt.Println(slotsRange)

	dishIDs, err := s.getDishIDsForSlots(ctx, activeDietID, slotsRange)
	if err != nil {
		return nil, err
	}
	// if len(dishIDs) != 5 {
	// 	return nil, fmt.Errorf("expected 5 dish slots, got %d", len(dishIDs))
	// }
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

	summary := model.MenuSummary{
		Kcal:         round2(sumKcal),
		Proteins:     round2(sumProtein),
		Fats:         round2(sumFat),
		Carbs:        round2(sumCarbs),
		KcalGoal:     round2(dayKcalGoal),                // Example calculation, adjust as needed
		ProteinPerKg: round2(sumProtein / currentWeight), // Example calculation, adjust as needed
		FatsPerc:     round2(sumFat * 9 / sumKcal * 100), // Example percentage, adjust as needed
		CarbsPerKg:   round2(sumCarbs / currentWeight),   // Example calculation, adjust as needed
	}

	menu := &model.Menu{
		Breakfast:   model.DishInMenu{Dish: dishes[0], SlotNum: &slotsRange[0]},
		Lunch:       model.DishInMenu{Dish: dishes[1], SlotNum: &slotsRange[1]},
		PreWorkout:  model.DishInMenu{Dish: dishes[2], SlotNum: &slotsRange[2]},
		PostWorkout: model.DishInMenu{Dish: dishes[3], SlotNum: &slotsRange[3]},
		Supper:      model.DishInMenu{Dish: dishes[4], SlotNum: &slotsRange[4]},
		Summary:     summary,
	}

	return menu, nil
}

func getMenuSlotsRange(currentDietDay int) []int {
	if currentDietDay <= 0 {
		return []int{}
	}

	// 7. dzień tygodnia (niedziela, jeśli tydzień zaczyna się od poniedziałku)
	if (currentDietDay-1)%7 == 6 {
		return []int{}
	}

	// Liczba pełnych cykli 7-dniowych
	weekIndex := (currentDietDay - 1) / 7

	// Pozycja w cyklu (0–5)
	posInWeek := (currentDietDay - 1) % 7

	// Który to "slotowy dzień" globalnie (pomijając niedziele)
	slotIndex := weekIndex*6 + posInWeek

	start := 1 + slotIndex*5
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

	return dishIDs, nil
}
