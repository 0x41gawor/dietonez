package service

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"

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

func (s *ServiceIngredients) ListPaginated(ctx context.Context, page, pageSize int, short bool) (any, int, error) {
	offset := (page - 1) * pageSize

	// Zliczanie wszystkich wierszy do total
	var total int
	err := s.db.QueryRowContext(ctx, `SELECT COUNT(*) FROM ingredients`).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("count ingredients: %w", err)
	}

	if short {
		const qShort = `
			SELECT id, name
			FROM ingredients
			ORDER BY id
			LIMIT $1 OFFSET $2;
		`
		rows, err := s.db.QueryContext(ctx, qShort, pageSize, offset)
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
		rows, err := s.db.QueryContext(ctx, qFull, pageSize, offset)
		if err != nil {
			return nil, 0, fmt.Errorf("query ingredients (full): %w", err)
		}
		defer rows.Close()

		var out []*model.IngredientGetPut
		idToIngredient := make(map[int]*model.IngredientGetPut)
		var ids []int

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
			idToIngredient[ing.ID] = ing
			ids = append(ids, ing.ID)
		}
		if err := rows.Err(); err != nil {
			return nil, 0, fmt.Errorf("rows full err: %w", err)
		}

		// Etap: pobranie etykiet
		if len(ids) > 0 {
			placeholders := make([]string, len(ids))
			args := make([]any, len(ids))
			for i, id := range ids {
				placeholders[i] = fmt.Sprintf("$%d", i+1)
				args[i] = id
			}

			qLabels := fmt.Sprintf(`
				SELECT b.ingredient_id, l.label, l.color
				FROM ingredient_label_bridge b
				JOIN ingredient_labels l ON l.id = b.label_id
				WHERE b.ingredient_id IN (%s)
			`, strings.Join(placeholders, ", "))

			rows, err := s.db.QueryContext(ctx, qLabels, args...)
			if err != nil {
				return nil, 0, fmt.Errorf("query labels: %w", err)
			}
			defer rows.Close()

			for rows.Next() {
				var ingID int
				var label model.Label
				if err := rows.Scan(&ingID, &label.Text, &label.Color); err != nil {
					return nil, 0, fmt.Errorf("scan label: %w", err)
				}
				if ing, ok := idToIngredient[ingID]; ok {
					ing.Labels = append(ing.Labels, label)
				}
			}
			if err := rows.Err(); err != nil {
				return nil, 0, fmt.Errorf("rows label err: %w", err)
			}
		}

		return out, total, nil
	}
}

func (s *ServiceIngredients) Create(ctx context.Context, in *model.IngredientPost) (int, error) {
	const q = `
		INSERT INTO ingredients (name, unit, default_amount, shop_style, kcal, proteins, fats, carbs)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
		RETURNING id;
	`

	var id int
	err := s.db.QueryRowContext(ctx, q,
		in.Name,
		in.Unit,
		in.DefaultAmount,
		in.ShopStyle,
		in.Kcal,
		in.Protein,
		in.Fat,
		in.Carbs,
	).Scan(&id)
	if err != nil {
		return 0, fmt.Errorf("insert ingredient: %w", err)
	}
	return id, nil
}

func (s *ServiceIngredients) CreateBulk(ctx context.Context, list []model.IngredientPost) (int, error) {
	const q = `
		INSERT INTO ingredients (name, unit, default_amount, shop_style, kcal, proteins, fats, carbs)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8);
	`

	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return 0, fmt.Errorf("begin tx: %w", err)
	}
	defer tx.Rollback()

	stmt, err := tx.PrepareContext(ctx, q)
	if err != nil {
		return 0, fmt.Errorf("prepare stmt: %w", err)
	}
	defer stmt.Close()

	created := 0
	for _, ing := range list {
		_, err := stmt.ExecContext(ctx,
			ing.Name,
			ing.Unit,
			ing.DefaultAmount,
			ing.ShopStyle,
			ing.Kcal,
			ing.Protein,
			ing.Fat,
			ing.Carbs,
		)
		if err != nil {
			return created, fmt.Errorf("exec insert #%d: %w", created+1, err)
		}
		created++
	}

	if err := tx.Commit(); err != nil {
		return created, fmt.Errorf("commit: %w", err)
	}
	return created, nil
}

func (s *ServiceIngredients) UpdateBulk(ctx context.Context, list []model.IngredientGetPut) (int, error) {
	const q = `
		UPDATE ingredients
		SET name = $2,
		    unit = $3,
		    default_amount = $4,
		    shop_style = $5,
		    kcal = $6,
		    proteins = $7,
		    fats = $8,
		    carbs = $9
		WHERE id = $1;
	`

	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return 0, fmt.Errorf("begin tx: %w", err)
	}
	defer tx.Rollback()

	stmt, err := tx.PrepareContext(ctx, q)
	if err != nil {
		return 0, fmt.Errorf("prepare update stmt: %w", err)
	}
	defer stmt.Close()

	updated := 0
	for _, ing := range list {
		res, err := stmt.ExecContext(ctx,
			ing.ID,
			ing.Name,
			ing.Unit,
			ing.DefaultAmount,
			ing.ShopStyle,
			ing.Kcal,
			ing.Protein,
			ing.Fat,
			ing.Carbs,
		)
		if err != nil {
			return updated, fmt.Errorf("exec update #%d: %w", updated+1, err)
		}
		rowsAffected, _ := res.RowsAffected()
		if rowsAffected > 0 {
			updated++
		}
	}

	if err := tx.Commit(); err != nil {
		return updated, fmt.Errorf("commit: %w", err)
	}
	return updated, nil
}

func (s *ServiceIngredients) GetByID(ctx context.Context, id int) (*model.IngredientGetPut, error) {
	const q = `
		SELECT id, name, unit, default_amount, shop_style,
		       kcal, proteins, fats, carbs
		FROM ingredients
		WHERE id = $1;
	`

	ing := new(model.IngredientGetPut)
	err := s.db.QueryRowContext(ctx, q, id).Scan(
		&ing.ID,
		&ing.Name,
		&ing.Unit,
		&ing.DefaultAmount,
		&ing.ShopStyle,
		&ing.Kcal,
		&ing.Protein,
		&ing.Fat,
		&ing.Carbs,
	)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil // not found
	}
	if err != nil {
		return nil, fmt.Errorf("get ingredient by id: %w", err)
	}
	return ing, nil
}

func (s *ServiceIngredients) DeleteByID(ctx context.Context, id int) error {
	const q = `
		DELETE FROM ingredients
		WHERE id = $1;
	`

	res, err := s.db.ExecContext(ctx, q, id)
	if err != nil {
		// Jeśli składnik jest używany w daniu (klucz obcy), PostgreSQL zgłosi błąd naruszenia ograniczenia
		if strings.Contains(err.Error(), "violates foreign key constraint") {
			return fmt.Errorf("used_in_dish")
		}
		return fmt.Errorf("delete ingredient: %w", err)
	}

	rows, _ := res.RowsAffected()
	if rows == 0 {
		return sql.ErrNoRows
	}

	return nil
}
