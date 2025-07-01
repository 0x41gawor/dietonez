package service

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
	_ "github.com/jackc/pgx/v5/stdlib"
)

type ServiceIngredients struct {
	db *sql.DB
}

func NewServiceIngredients() *ServiceIngredients {
	db := repo.GetDatabaseInstance().DB
	return &ServiceIngredients{db: db}
}

// List zwraca wszystkie składniki z tabeli "ingredients".
func (s *ServiceIngredients) ListPaginated(ctx context.Context, page, pageSize int, short bool) (any, int, error) {
	offset := (page - 1) * pageSize

	// Zliczanie wszystkich wierszy do total
	var total int
	err := s.db.QueryRowContext(ctx, `SELECT COUNT(*) FROM ingredients`).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("count ingredients: %w", err)
	}

	// Główne zapytanie
	var rows *sql.Rows
	if short {
		const qShort = `
			SELECT id, name
			FROM ingredients
			ORDER BY id
			LIMIT $1 OFFSET $2;
		`
		rows, err = s.db.QueryContext(ctx, qShort, pageSize, offset)
		if err != nil {
			return nil, 0, fmt.Errorf("query ingredients (short): %w", err)
		}
		defer rows.Close()

		var out []*model.IngredientMin
		for rows.Next() {
			ing := new(model.IngredientMin)
			if err := rows.Scan(&ing.ID, &ing.Name); err != nil {
				return nil, 0, fmt.Errorf("scan short: %w", err)
			}
			out = append(out, ing)
		}
		if err := rows.Err(); err != nil {
			return nil, 0, fmt.Errorf("rows short err: %w", err)
		}
		return out, total, nil

	} else {
		const qFull = `
			SELECT id, name, unit, default_amount, shop_style,
			       kcal, proteins, fats, carbs
			FROM ingredients
			ORDER BY id
			LIMIT $1 OFFSET $2;
		`
		rows, err = s.db.QueryContext(ctx, qFull, pageSize, offset)
		if err != nil {
			return nil, 0, fmt.Errorf("query ingredients (full): %w", err)
		}
		defer rows.Close()

		var out []*model.IngredientGetPut
		for rows.Next() {
			ing := new(model.IngredientGetPut)
			if err := rows.Scan(
				&ing.ID,
				&ing.Name,
				&ing.Unit,
				&ing.DefaultAmount,
				&ing.ShopStyle,
				&ing.Kcal,
				&ing.Protein,
				&ing.Fat,
				&ing.Carbs,
			); err != nil {
				return nil, 0, fmt.Errorf("scan full: %w", err)
			}
			out = append(out, ing)
		}
		if err := rows.Err(); err != nil {
			return nil, 0, fmt.Errorf("rows full err: %w", err)
		}
		return out, total, nil
	}
}
