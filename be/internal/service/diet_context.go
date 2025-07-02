package service

import (
	"context"
	"database/sql"
	"fmt"

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

func (s *ServiceDietContext) Get(ctx context.Context) (*model.DietContext, error) {
	const q = `
		SELECT dc.active_diet, dc.current_week, dc.current_weekday, dc.current_weight,
		       d.name
		FROM diet_contexts dc
		LEFT JOIN diets d ON d.id = dc.active_diet;
	`

	var dc model.DietContext
	err := s.db.QueryRowContext(ctx, q).Scan(
		&dc.ActiveDiet.ID,
		&dc.CurrentWeek,
		&dc.CurrentDay,
		&dc.Weight,
		&dc.ActiveDiet.Name,
	)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("query context: %w", err)
	}

	return &dc, nil
}

func (s *ServiceDietContext) Update(ctx context.Context, in *model.DietContext) (*model.DietContext, error) {
	// 1. Usuń istniejący rekord (bo mamy tylko jeden – singleton)
	const delQ = `DELETE FROM diet_contexts;`
	if _, err := s.db.ExecContext(ctx, delQ); err != nil {
		return nil, fmt.Errorf("delete old context: %w", err)
	}

	// 2. Wstaw nowy
	const insertQ = `
		INSERT INTO diet_contexts (active_diet, current_week, current_weekday, current_weight)
		VALUES ($1, $2, $3, $4);
	`
	_, err := s.db.ExecContext(ctx, insertQ,
		in.ActiveDiet.ID,
		in.CurrentWeek,
		in.CurrentDay,
		in.Weight,
	)
	if err != nil {
		return nil, fmt.Errorf("insert new context: %w", err)
	}

	// 3. Zwróć aktualny stan
	return s.Get(ctx)
}
