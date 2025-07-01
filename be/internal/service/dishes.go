package service

import (
	"context"
	"database/sql"
	"fmt"

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
