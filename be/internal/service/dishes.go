package service

import (
	"context"
	"database/sql"
	"fmt"
	"strings"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceDishes struct {
	db *sql.DB
}

func NewServiceDishes() *ServiceDishes {
	db := repo.GetDatabaseInstance().DB
	return &ServiceDishes{db: db}
}

func (s *ServiceDishes) ListByMeal(
	ctx context.Context,
	meal string,
) ([]*model.DishGetShort, error) {

	const q = `
		SELECT
			d.id,
			d.name,
			COALESCE(SUM(ia.amount / ing.default_amount * ing.kcal), 0)     AS kcal,
			COALESCE(SUM(ia.amount / ing.default_amount * ing.proteins), 0) AS protein,
			COALESCE(SUM(ia.amount / ing.default_amount * ing.fats), 0)     AS fat,
			COALESCE(SUM(ia.amount / ing.default_amount * ing.carbs), 0)    AS carbs
		FROM dishes              d
		LEFT JOIN ingredient_amounts ia ON ia.dish_id      = d.id
		LEFT JOIN ingredients        ing ON ing.id         = ia.ingredient_id
		WHERE d.meal = $1
		GROUP BY d.id, d.name, d.meal
		ORDER BY d.name;
	`

	rows, err := s.db.QueryContext(ctx, q, meal)
	if err != nil {
		return nil, fmt.Errorf("query dishes by meal: %w", err)
	}
	defer rows.Close()

	var out []*model.DishGetShort
	for rows.Next() {
		d := new(model.DishGetShort)
		if err := rows.Scan(
			&d.ID,
			&d.Name,
			&d.Kcal,
			&d.Protein,
			&d.Fat,
			&d.Carbs,
		); err != nil {
			return nil, fmt.Errorf("scan dish: %w", err)
		}
		out = append(out, d)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("rows err: %w", err)
	}
	return out, nil
}

func (s *ServiceDishes) GetByID(ctx context.Context, id int) (*model.DishGet, error) {
	const dishQuery = `
		SELECT id, name, meal, descr
		FROM dishes
		WHERE id = $1;
	`

	var dish model.DishGet
	err := s.db.QueryRowContext(ctx, dishQuery, id).Scan(&dish.ID, &dish.Name, &dish.Meal, &dish.Descr)
	if err == sql.ErrNoRows {
		return nil, nil // 404 later
	}
	if err != nil {
		return nil, fmt.Errorf("query dish: %w", err)
	}

	const ingredientsQuery = `
		SELECT i.id, i.name, i.unit, i.default_amount, i.shop_style, i.kcal, i.proteins, i.fats, i.carbs, ia.amount
		FROM ingredient_amounts ia
		JOIN ingredients i ON i.id = ia.ingredient_id
		WHERE ia.dish_id = $1;
	`

	rows, err := s.db.QueryContext(ctx, ingredientsQuery, id)
	if err != nil {
		return nil, fmt.Errorf("query ingredients for dish: %w", err)
	}
	defer rows.Close()

	var (
		totalKcal, totalProtein, totalFat, totalCarbs float64
		ingredients                                   []model.IngredientInDishGet
	)

	for rows.Next() {
		var ing model.IngredientGetPut
		var amount float64

		err := rows.Scan(
			&ing.ID,
			&ing.Name,
			&ing.Unit,
			&ing.DefaultAmount,
			&ing.ShopStyle,
			&ing.Kcal,
			&ing.Protein,
			&ing.Fat,
			&ing.Carbs,
			&amount,
		)
		if err != nil {
			return nil, fmt.Errorf("scan ingredient in dish: %w", err)
		}

		totalKcal += ing.Kcal * amount / 100
		totalProtein += ing.Protein * amount / 100
		totalFat += ing.Fat * amount / 100
		totalCarbs += ing.Carbs * amount / 100

		ingredients = append(ingredients, model.IngredientInDishGet{
			Ingredient: ing,
			Amount:     amount,
		})
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("rows error: %w", err)
	}

	// …

	// 3. pobierz powiązany przepis ---------------------------------------------
	const recipeQuery = `
	SELECT time_total, what_before, when_start, preparation
	FROM recipes
	WHERE dish_id = $1;
`

	var recipe model.Recipe
	err = s.db.QueryRowContext(ctx, recipeQuery, id).Scan(
		&recipe.TotalTime,
		&recipe.Before,
		&recipe.WhenToStart,
		&recipe.Preparation,
	)
	if err != nil && err != sql.ErrNoRows {
		return nil, fmt.Errorf("query recipe: %w", err)
	}

	// jeśli przepisu brak, zostaw puste pola (ErrNoRows to normalne)

	// 4. wypełnij strukturę i zwróć ---------------------------------------------
	dish.Kcal = totalKcal
	dish.Protein = totalProtein
	dish.Fat = totalFat
	dish.Carbs = totalCarbs
	dish.Ingredients = ingredients
	dish.Recipe = recipe // <-- NOWE

	return &dish, nil

}

func (s *ServiceDishes) Create(ctx context.Context, in *model.DishPost) (*model.DishGet, error) {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("begin tx: %w", err)
	}
	defer tx.Rollback()

	// 1. Insert into dishes
	const qDish = `
		INSERT INTO dishes (name, meal, descr)
		VALUES ($1, $2, $3)
		RETURNING id;
	`
	var dishID int
	err = tx.QueryRowContext(ctx, qDish, in.Name, in.Meal, in.Descr).Scan(&dishID)
	if err != nil {
		return nil, fmt.Errorf("insert dish: %w", err)
	}

	// 2. Insert ingredients (ingredient_amounts)
	const qIng = `
		INSERT INTO ingredient_amounts (dish_id, ingredient_id, amount)
		VALUES ($1, $2, $3);
	`
	stmtIng, err := tx.PrepareContext(ctx, qIng)
	if err != nil {
		return nil, fmt.Errorf("prepare ingredients: %w", err)
	}
	defer stmtIng.Close()

	for _, ing := range in.Ingredients {
		_, err := stmtIng.ExecContext(ctx, dishID, ing.Ingredient.ID, ing.Amount)
		if err != nil {
			return nil, fmt.Errorf("insert ingredient: %w", err)
		}
	}

	// 3. Insert labels (dish_label_bridges)
	if len(in.Labels) > 0 {
		const qLabel = `
			INSERT INTO dish_label_bridges (dish_id, label_id)
			SELECT $1, id FROM dish_labels WHERE label = $2 AND color = $3;
		`
		stmtLab, err := tx.PrepareContext(ctx, qLabel)
		if err != nil {
			return nil, fmt.Errorf("prepare labels: %w", err)
		}
		defer stmtLab.Close()

		for _, lbl := range in.Labels {
			_, err := stmtLab.ExecContext(ctx, dishID, lbl.Text, lbl.Color)
			if err != nil {
				return nil, fmt.Errorf("insert label: %w", err)
			}
		}
	}

	// 4. Insert recipe
	const qRecipe = `
		INSERT INTO recipes (dish_id, time_total, what_before, when_start, preparation)
		VALUES ($1, $2, $3, $4, $5);
	`
	_, err = tx.ExecContext(ctx, qRecipe,
		dishID,
		in.Recipe.TotalTime,
		in.Recipe.Before,
		in.Recipe.WhenToStart,
		in.Recipe.Preparation,
	)
	if err != nil {
		return nil, fmt.Errorf("insert recipe: %w", err)
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("commit: %w", err)
	}

	// Use existing logic to return the created object
	return s.GetByID(ctx, dishID)
}

func (s *ServiceDishes) Update(ctx context.Context, id int, in *model.DishPut) (*model.DishGet, error) {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("begin tx: %w", err)
	}
	defer tx.Rollback()

	// 1. Update main dish fields
	const qDish = `
		UPDATE dishes
		SET name = $1, meal = $2, descr = $3
		WHERE id = $4;
	`
	res, err := tx.ExecContext(ctx, qDish, in.Name, in.Meal, in.Descr, id)
	if err != nil {
		return nil, fmt.Errorf("update dish: %w", err)
	}
	rows, _ := res.RowsAffected()
	if rows == 0 {
		return nil, sql.ErrNoRows
	}

	// 2. Delete old ingredient_amounts
	_, err = tx.ExecContext(ctx, `DELETE FROM ingredient_amounts WHERE dish_id = $1`, id)
	if err != nil {
		return nil, fmt.Errorf("clear ingredients: %w", err)
	}

	// 3. Insert new ingredients
	const qIng = `
		INSERT INTO ingredient_amounts (dish_id, ingredient_id, amount)
		VALUES ($1, $2, $3);
	`
	stmtIng, err := tx.PrepareContext(ctx, qIng)
	if err != nil {
		return nil, fmt.Errorf("prepare ingredients: %w", err)
	}
	defer stmtIng.Close()

	for _, ing := range in.Ingredients {
		_, err := stmtIng.ExecContext(ctx, id, ing.Ingredient.ID, ing.Amount)
		if err != nil {
			return nil, fmt.Errorf("insert ingredient: %w", err)
		}
	}

	// 4. Delete & reinsert labels
	_, err = tx.ExecContext(ctx, `DELETE FROM dish_label_bridges WHERE dish_id = $1`, id)
	if err != nil {
		return nil, fmt.Errorf("clear labels: %w", err)
	}

	const qLabel = `
		INSERT INTO dish_label_bridges (dish_id, label_id)
		SELECT $1, id FROM dish_labels WHERE label = $2 AND color = $3;
	`
	stmtLabel, err := tx.PrepareContext(ctx, qLabel)
	if err != nil {
		return nil, fmt.Errorf("prepare labels: %w", err)
	}
	defer stmtLabel.Close()

	for _, lbl := range in.Labels {
		_, err := stmtLabel.ExecContext(ctx, id, lbl.Text, lbl.Color)
		if err != nil {
			return nil, fmt.Errorf("insert label: %w", err)
		}
	}

	// 5. Upsert recipe
	const qRecipe = `
		INSERT INTO recipes (dish_id, time_total, what_before, when_start, preparation)
		VALUES ($1, $2, $3, $4, $5)
		ON CONFLICT (dish_id) DO UPDATE SET
			time_total = EXCLUDED.time_total,
			what_before = EXCLUDED.what_before,
			when_start = EXCLUDED.when_start,
			preparation = EXCLUDED.preparation;
	`
	_, err = tx.ExecContext(ctx, qRecipe,
		id,
		in.Recipe.TotalTime,
		in.Recipe.Before,
		in.Recipe.WhenToStart,
		in.Recipe.Preparation,
	)
	if err != nil {
		return nil, fmt.Errorf("upsert recipe: %w", err)
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("commit: %w", err)
	}

	return s.GetByID(ctx, id)
}

func (s *ServiceDishes) DeleteByID(ctx context.Context, id int) error {
	const q = `
		DELETE FROM dishes
		WHERE id = $1;
	`

	res, err := s.db.ExecContext(ctx, q, id)
	if err != nil {
		// Jeśli danie jest przypisane do diety (diet_slots), baza wyrzuci błąd klucza obcego
		if strings.Contains(err.Error(), "violates foreign key constraint") {
			return fmt.Errorf("used_in_diet")
		}
		return fmt.Errorf("delete dish: %w", err)
	}

	rows, _ := res.RowsAffected()
	if rows == 0 {
		return sql.ErrNoRows
	}

	return nil
}
