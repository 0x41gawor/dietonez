package service

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceDietContext struct {
	db *sql.DB
}

func NewServiceDietContext() *ServiceDietContext {
	db := repo.GetDatabaseInstance().DB
	return &ServiceDietContext{db: db}
}

func (s *ServiceDietContext) GetCurrentDietDay(ctx context.Context, date time.Time) (int, error) {
	dietContext, err := repo.NewRepositoryDietContext().Get()
	if err != nil {
		return 0, fmt.Errorf("get diet context: %w", err)
	}
	startDate := dietContext.StartDate.Truncate(24 * time.Hour)
	if startDate.Weekday() != time.Monday {
		return 0, fmt.Errorf("invalid start_date in diet context: expected Monday, got %s", startDate.Weekday().String())
	}

	maxSlotNum, err := repo.NewRepositoryDietSlots().GetMaxSlotNumByDietId(dietContext.ActiveDietID)
	if err != nil {
		return 0, fmt.Errorf("get max slot num: %w", err)
	}

	// obliczenie różnicy dni (startDate → date)
	daysBetween := int(date.Sub(startDate).Hours() / 24)
	print("daysBetween:", daysBetween, "\n")
	if daysBetween < 0 {
		return 0, fmt.Errorf("current date is before start date")
	}

	maxDietDay := (maxSlotNum + 1) / 5
	print("maxDietDay:", maxDietDay, "\n")
	currentDietDay := daysBetween % maxDietDay
	print("currentDietDay:", currentDietDay, "\n")
	return currentDietDay, nil
}

func (s *ServiceDietContext) Get(ctx context.Context) (*model.DietContextGet, error) {
	const q = `
		SELECT dc.active_diet, dc.start_date, dc.current_weight,
		       d.name
		FROM diet_context dc
		LEFT JOIN diets d ON d.id = dc.active_diet;
	`

	var dc model.DietContextGet
	err := s.db.QueryRowContext(ctx, q).Scan(
		&dc.ActiveDiet.ID,
		&dc.StartDate,
		&dc.Weight,
		&dc.ActiveDiet.Name,
	)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("query context: %w", err)
	}

	// 1. Pobierz dzisiejszą datę (tylko data, bez czasu)
	today := time.Now().Truncate(24 * time.Hour)
	start := dc.StartDate.Truncate(24 * time.Hour)

	// 2. Policz różnicę dni
	daysSinceStart := int(today.Sub(start).Hours()/24) + 1
	// 3. Oblicz liczbę pełnych tygodni (jeśli 0, to tydzień 1)
	if daysSinceStart < 0 {
		dc.CurrentWeek = 1 // przyszłość? fallback na 1
		dc.CurrentDay = 1
	} else {
		dc.CurrentWeek = daysSinceStart/7 + 1

		// 4. Oblicz currentDay: Monday = 1, Sunday = 7
		weekday := today.Weekday()
		if weekday == time.Sunday {
			dc.CurrentDay = 7
		} else {
			dc.CurrentDay = int(weekday)
		}
	}

	return &dc, nil
}

func (s *ServiceDietContext) Update(ctx context.Context, in *model.DietContextPut) (*model.DietContextGet, error) {
	// 0. Walidacja: start date musi być poniedziałkiem
	if in.StartDate.Weekday() != time.Monday {
		return nil, fmt.Errorf("start_date must be a Monday (got %s)", in.StartDate.Weekday())
	}

	// 1. Usuń istniejący rekord (bo mamy tylko jeden – singleton)
	const delQ = `DELETE FROM diet_context;`
	if _, err := s.db.ExecContext(ctx, delQ); err != nil {
		return nil, fmt.Errorf("delete old context: %w", err)
	}

	// 2. Wstaw nowy
	const insertQ = `
		INSERT INTO diet_context (active_diet, start_date, current_weight)
		VALUES ($1, $2, $3);
	`
	_, err := s.db.ExecContext(ctx, insertQ,
		in.ActiveDiet.ID,
		in.StartDate,
		in.Weight,
	)
	if err != nil {
		return nil, fmt.Errorf("insert new context: %w", err)
	}

	// 3. Zwróć aktualny stan
	return s.Get(ctx)
}
