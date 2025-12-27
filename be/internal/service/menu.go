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
	// Pobieramy DietContext czyli {ActiveDietID, ActiveDietStartDate, CurrentWeight}
	dietContext, err := repo.NewRepositoryDietContext().Get()
	fmt.Println("ActiveDietId: ", dietContext.ActiveDietID)
	if err != nil {
		return nil, fmt.Errorf("get diet context: %w", err)
	}
	// Obliczamy aktualny dzień diety na podstawie ActiveDietStartDate i date zapytania
	currentDietDay, err := NewServiceDietContext().GetCurrentDietDay(ctx, date)
	if err != nil {
		return nil, fmt.Errorf("get current diet day: %w", err)
	}
	// Obliczamy slotsRange dla danego dnia (np. dzień 0 to sloty 0-4, dzień 1 to sloty 5-9, itd.)
	slotsRange := getMenuSlotsRange(currentDietDay)
	fmt.Println("SlotsRange: ", slotsRange)
	// Pobieramy dishIDs dla slotów z diet_slots
	dishIDs, err := s.getDishIDsForSlots(ctx, dietContext.ActiveDietID, slotsRange)
	if err != nil {
		return nil, err
	}
	// Jeśli data jest w oknie 2 tygodni od dzisiaj, pobieramy menu z ServiceCounter
	if s.IsInTwoWeeksWindow(date) {
		return NewServiceCounter().Get(ctx, dietContext, date, dishIDs, slotsRange, currentDietDay)
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
	// fetch kcal goal
	dayKcalGoal, err := repo.NewRepositoryDayKcals().GetKcalByDietIdAndDayNum(dietContext.ActiveDietID, currentDietDay)
	if err != nil {
		return nil, fmt.Errorf("get day kcal goal: %w", err)
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
		ProteinPerKg: round2(sumProtein / dietContext.CurrentWeight),
		FatsPerc:     fatsPerc,
		CarbsPerKg:   round2(sumCarbs / dietContext.CurrentWeight),
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
	return dishIDs, nil
}

func (s *ServiceMenu) IsInTwoWeeksWindow(date time.Time) bool {
	currentDate := time.Now().Truncate(24 * time.Hour)

	diff := date.Sub(currentDate)
	daysDiff := int(diff.Hours() / 24)

	if math.Abs(float64(daysDiff)) <= 7 {
		return true
	}
	return false
}

func (s *ServiceMenu) GetSummary(ctx context.Context, date time.Time) (*model.MenuSummary, error) {
	menu, err := s.Get(ctx, date)
	if err != nil {
		return nil, fmt.Errorf("get menu for summary: %w", err)
	}
	return &menu.Summary, nil
}
