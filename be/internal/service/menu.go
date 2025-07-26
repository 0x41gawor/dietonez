package service

import (
	"context"
	"database/sql"
	"fmt"
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

	err := s.db.QueryRowContext(ctx, `
		SELECT active_diet, start_date
		FROM diet_context
		LIMIT 1
	`).Scan(&activeDietID, &startDate)

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
	if len(dishIDs) != 5 {
		return nil, fmt.Errorf("expected 5 dish slots, got %d", len(dishIDs))
	}

	var dishes [5]*model.DishGet
	for i, id := range dishIDs {
		if id == 0 {
			return nil, fmt.Errorf("slot %d has no dish assigned", slotsRange[i])
		}
		dish, err := s.dishes.GetByID(ctx, id)
		if err != nil {
			return nil, fmt.Errorf("fetch dish %d: %w", id, err)
		}
		dishes[i] = dish
	}

	menu := &model.Menu{
		Breakfast:   *dishes[0],
		Lunch:       *dishes[1],
		PreWorkout:  *dishes[2],
		PostWorkout: *dishes[3],
		Supper:      *dishes[4],
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
