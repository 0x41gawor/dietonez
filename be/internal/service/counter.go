package service

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceCounter struct {
	db     *sql.DB
	dishes *ServiceDishes
}

func NewServiceCounter() *ServiceCounter {
	db := repo.GetDatabaseInstance().DB
	return &ServiceCounter{db: db, dishes: NewServiceDishes()}
}

func (s *ServiceCounter) Get(ctx context.Context, date time.Time, dishIDs []int, slotsRange []int) (*model.Menu, error) {
	// sprawdzamy, czy data istnieje w tabeli counter
	exists, err := s.IsDateInTable(ctx, date)
	if err != nil {
		return nil, err
	}
	if !exists {

		// jeśli nie istnieje to wykonujemy operacje kopiowania skłądników na ten dzień według tabeli diet_slots i dishes
		s.CopyToCounter(ctx, date, dishIDs) // tymczasowo puste dania
	}

	// jeśli istnieje to pobieramy składniki z tabeli counter
	menu, erctxr := s.GetMenuForDate(ctx, date, dishIDs, slotsRange)
	if erctxr != nil {
		return nil, erctxr
	}
	// zwracamy menu
	return menu, nil
}

func (s *ServiceCounter) IsDateInTable(ctx context.Context, date time.Time) (bool, error) {
	var exists bool
	err := s.db.QueryRowContext(ctx, `
		SELECT EXISTS (
			SELECT 1
			FROM counter
			WHERE day = $1)
	`, date).Scan(&exists)
	if err != nil {
		return false, err
	}
	return exists, nil
}

func (s *ServiceCounter) RemoveDateFromTable(ctx context.Context, date time.Time) error {
	_, err := s.db.ExecContext(ctx, `
		DELETE FROM counter
		WHERE day = $1
	`, date)
	if err != nil {
		return err
	}
	return nil
}

// This method copies the menu for the given day (usually current) to the counter table.
func (s *ServiceCounter) CopyToCounter(ctx context.Context, date time.Time, dishIDs []int) error {
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

func (s *ServiceCounter) AddIngredientsToCounter(ctx context.Context, date time.Time, mealSlot string, ingredients []model.IngredientInDishGet) error {
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

func (s *ServiceCounter) GetMenuForDate(ctx context.Context, date time.Time, dishIDs []int, slotsRange []int) (*model.Menu, error) {
	// Pobierz składniki z tabeli counter dla danego dnia
	rows, err := s.db.QueryContext(ctx, `
		SELECT meal, ingredient_id, amount
		FROM counter
		WHERE day = $1
	`, date)
	if err != nil {
		return nil, fmt.Errorf("query counter: %w", err)
	}
	defer rows.Close()
	// Mapa: meal → []IngredientInDishGet
	mealMap := make(map[string][]model.IngredientInDishGet)
	for rows.Next() {
		var meal string
		var ingredientID int
		var amount float64
		if err := rows.Scan(&meal, &ingredientID, &amount); err != nil {
			return nil, fmt.Errorf("scan row: %w", err)
		}
		ingredient, err := NewServiceIngredients().GetByID(ctx, ingredientID)
		if err != nil {
			return nil, fmt.Errorf("fetch ingredient %d: %w", ingredientID, err)
		}
		ingInDish := model.IngredientInDishGet{
			Ingredient: *ingredient,
			Amount:     amount,
		}
		mealMap[meal] = append(mealMap[meal], ingInDish)
	}
	dishes := make([]*model.DishGet, 5)
	for i, dishID := range dishIDs {
		if dishID == 0 {
			dishes[i] = nil
			continue
		}
		dishTemp, err := NewServiceDishes().GetCounterByID(ctx, dishID)
		if err != nil {
			return nil, fmt.Errorf("fetch dish %d: %w", dishID, err)
		}
		switch i {
		case 0:
			dishTemp.Ingredients = mealMap["Breakfast"]
		case 1:
			dishTemp.Ingredients = mealMap["Lunch"]
		case 2:
			dishTemp.Ingredients = mealMap["Pre-Workout"]
		case 3:
			dishTemp.Ingredients = mealMap["Post-Workout"]
		case 4:
			dishTemp.Ingredients = mealMap["Supper"]
		}
		dishes[i] = dishTemp
	}
	// Teraz zbuduj strukturę Menu z pobranymi danymi
	menu := &model.Menu{
		Breakfast:   model.DishInMenu{Dish: dishes[0], SlotNum: slotsRange[0]},
		Lunch:       model.DishInMenu{Dish: dishes[1], SlotNum: slotsRange[1]},
		PreWorkout:  model.DishInMenu{Dish: dishes[2], SlotNum: slotsRange[2]},
		PostWorkout: model.DishInMenu{Dish: dishes[3], SlotNum: slotsRange[3]},
		Supper:      model.DishInMenu{Dish: dishes[4], SlotNum: slotsRange[4]},
		Summary:     model.MenuSummary{}, // Możesz dodać podsumowanie, jeśli potrzebne
	}

	//Policz Summary z ingredients

	return menu, nil
}
