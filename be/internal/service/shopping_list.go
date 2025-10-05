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

type ServiceShoppingList struct {
	db *sql.DB
}

func NewServiceShoppingList() *ServiceShoppingList {
	db := repo.GetDatabaseInstance().DB
	return &ServiceShoppingList{db: db}
}

func (s *ServiceShoppingList) Get(ctx context.Context, date time.Time) (*model.ShoppingList, error) {
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

	// Obliczenie różnicy dni (startDate → date)
	daysBetween := int(date.Sub(startDate).Hours() / 24)
	if daysBetween < 0 {
		return nil, fmt.Errorf("current date is before start date")
	}

	maxDietDay := (maxSlotNum+1)/5 - 1 // ostatni dzień diety (0‑based)
	currentDietDay := daysBetween % (maxDietDay + 1)
	print("Shopping List - startDate:", startDate.String()[:11], "\n")
	print("Shopping List - date:", date.String()[:11], "\n")
	print("Shopping List - daysBetween:", daysBetween, "\n")
	print("Shopping List - currentDietDay:", currentDietDay, "\n")
	print("Shopping List - maxDietDay:", maxDietDay, "\n")

	freshSlotsRange := getFreshSlotsRange(currentDietDay, maxDietDay)
	lidlAndStockSlotsRange := getLidlAndStockSlotsRange(currentDietDay, maxDietDay)

	freshIngredients, err := s.getFreshIngredients(ctx, activeDietID, freshSlotsRange)
	if err != nil {
		return nil, fmt.Errorf("getFreshIngredients: %w", err)
	}
	stockIngredients, err := s.getStockIngredients(ctx, activeDietID, lidlAndStockSlotsRange)
	if err != nil {
		return nil, fmt.Errorf("getStockIngredients: %w", err)
	}
	lidlIngredients, err := s.getLidlIngredients(ctx, activeDietID, lidlAndStockSlotsRange)
	if err != nil {
		return nil, fmt.Errorf("getLidlIngredients: %w", err)
	}
	liveIngredients, err := s.getLiveIngredients(ctx, activeDietID, freshSlotsRange)
	if err != nil {
		return nil, fmt.Errorf("getLiveIngredients: %w", err)
	}
	gsIngredients, err := s.getGSIngredients(ctx, activeDietID, freshSlotsRange)
	if err != nil {
		return nil, fmt.Errorf("getGSIngredients: %w", err)
	}
	result := &model.ShoppingList{
		Fresh: freshIngredients,
		Lidl:  lidlIngredients,
		Stock: stockIngredients,
		Live:  liveIngredients,
		GS:    gsIngredients,
	}

	return result, nil
}

func getFreshSlotsRange(currentDietDay, maxDietDay int) []int {

	// Specjalny przypadek: dzień przed ostatnim
	if currentDietDay == maxDietDay {
		print("Fresh: return [0..4]\n")
		return []int{0, 1, 2, 3, 4}
	}

	start := (currentDietDay + 1) * 5

	print("Fresh: return [", start, "..", start+4, "]\n")

	return []int{start, start + 1, start + 2, start + 3, start + 4}
}

// Lidl & Zapasy: zwraca ciąg 15‑slotowy lub pusty slice
func getLidlAndStockSlotsRange(currentDietDay, maxDietDay int) []int {
	if currentDietDay <= 0 {
		return []int{}
	}

	// Specjalny przypadek: dzień przed ostatnim
	if currentDietDay == maxDietDay-1 {
		print("Lidl: return [0..14]\n")
		return []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}
	}

	// Niedopuszczamy ostatniego dnia (maxDay) – ma być pusty
	if currentDietDay >= maxDietDay {
		return []int{}
	}

	posInWeek := (currentDietDay) % 7
	if posInWeek != 2 && posInWeek != 5 { // nie środa i nie sobota → brak slotów
		return []int{}
	}

	weekNum := (currentDietDay - 1) / 7 // ile pełnych tygodni minęło
	print("weekNum:", weekNum, "\n")
	print("posInWeek:", posInWeek, "\n")
	result := make([]int, 0, 20)
	if posInWeek == 2 { // środa
		start := weekNum*35 + 15
		for i := start; i < start+20; i++ {
			result = append(result, i)
		}
	} else { // sobota
		start := (weekNum + 1) * 35
		for i := start; i < start+15; i++ {
			result = append(result, i)
		}
	}
	for _, v := range result {
		print(v, " ")
	}
	return result
}

func (s *ServiceShoppingList) getFreshIngredients(ctx context.Context, dietID int, slotNums []int) ([]model.IngredientInShoppingList, error) {
	const q = `
		SELECT
		  i.id,
		  i.name,
		  i.unit,
		  i.default_amount,
		  i.kcal,
		  i.proteins,
		  i.fats,
		  i.carbs,
		  SUM(ia.amount) AS total_amount
		FROM diet_slots ds
		JOIN ingredient_amounts ia ON ia.dish_id = ds.dish_id
		JOIN ingredients i ON i.id = ia.ingredient_id
		WHERE ds.diet_id = $1
		  AND ds.slot_num = ANY($2)
		  AND i.shop_style = 'Świeże'
		GROUP BY i.id, i.name, i.unit, i.default_amount, i.kcal, i.proteins, i.fats, i.carbs
		ORDER BY i.name;
	`

	rows, err := s.db.QueryContext(ctx, q, dietID, pq.Array(slotNums))
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []model.IngredientInShoppingList
	for rows.Next() {
		var ing model.IngredientGetPut
		var amount float64

		err := rows.Scan(
			&ing.ID,
			&ing.Name,
			&ing.Unit,
			&ing.DefaultAmount,
			&ing.Kcal,
			&ing.Protein,
			&ing.Fat,
			&ing.Carbs,
			&amount,
		)
		if err != nil {
			return nil, err
		}

		ingMin := model.IngredientIdNameUnit{ID: ing.ID, Name: ing.Name, Unit: ing.Unit}

		result = append(result, model.IngredientInShoppingList{
			Ingredient: ingMin,
			Amount:     amount,
		})
	}

	return result, nil
}

func (s *ServiceShoppingList) getLidlIngredients(ctx context.Context, dietID int, slotNums []int) ([]model.IngredientInShoppingList, error) {
	const q = `
		SELECT
		  i.id,
		  i.name,
		  i.unit,
		  i.default_amount,
		  i.kcal,
		  i.proteins,
		  i.fats,
		  i.carbs,
		  i.path,
		  SUM(ia.amount) AS total_amount
		FROM diet_slots ds
		JOIN ingredient_amounts ia ON ia.dish_id = ds.dish_id
		JOIN ingredients i ON i.id = ia.ingredient_id
		WHERE ds.diet_id = $1
		  AND ds.slot_num = ANY($2)
		  AND i.shop_style IN ('Lidl')
		GROUP BY i.id, i.name, i.unit, i.default_amount, i.kcal, i.proteins, i.fats, i.carbs
		ORDER BY i.path ASC, i.name ASC;
	`

	rows, err := s.db.QueryContext(ctx, q, dietID, pq.Array(slotNums))
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []model.IngredientInShoppingList
	for rows.Next() {
		var ing model.IngredientGetPut
		var amount float64

		err := rows.Scan(
			&ing.ID,
			&ing.Name,
			&ing.Unit,
			&ing.DefaultAmount,
			&ing.Kcal,
			&ing.Protein,
			&ing.Fat,
			&ing.Carbs,
			&ing.Path,
			&amount,
		)
		if err != nil {
			return nil, err
		}

		ingMin := model.IngredientIdNameUnit{ID: ing.ID, Name: ing.Name, Unit: ing.Unit}

		result = append(result, model.IngredientInShoppingList{
			Ingredient: ingMin,
			Amount:     amount,
		})
	}

	return result, nil
}

func (s *ServiceShoppingList) getStockIngredients(ctx context.Context, dietID int, slotNums []int) ([]model.IngredientInShoppingList, error) {
	const q = `
		SELECT
		  i.id,
		  i.name,
		  i.unit,
		  i.default_amount,
		  i.kcal,
		  i.proteins,
		  i.fats,
		  i.carbs,
		  SUM(ia.amount) AS total_amount
		FROM diet_slots ds
		JOIN ingredient_amounts ia ON ia.dish_id = ds.dish_id
		JOIN ingredients i ON i.id = ia.ingredient_id
		WHERE ds.diet_id = $1
		  AND ds.slot_num = ANY($2)
		  AND i.shop_style IN ('Zapasy')
		GROUP BY i.id, i.name, i.unit, i.default_amount, i.kcal, i.proteins, i.fats, i.carbs
		ORDER BY i.name;
	`

	rows, err := s.db.QueryContext(ctx, q, dietID, pq.Array(slotNums))
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []model.IngredientInShoppingList
	for rows.Next() {
		var ing model.IngredientGetPut
		var amount float64

		err := rows.Scan(
			&ing.ID,
			&ing.Name,
			&ing.Unit,
			&ing.DefaultAmount,
			&ing.Kcal,
			&ing.Protein,
			&ing.Fat,
			&ing.Carbs,
			&amount,
		)
		if err != nil {
			return nil, err
		}

		ingMin := model.IngredientIdNameUnit{ID: ing.ID, Name: ing.Name, Unit: ing.Unit}

		result = append(result, model.IngredientInShoppingList{
			Ingredient: ingMin,
			Amount:     amount,
		})
	}

	return result, nil
}

func (s *ServiceShoppingList) getLiveIngredients(ctx context.Context, dietID int, slotNums []int) ([]model.IngredientInShoppingList, error) {
	const q = `
		SELECT
		  i.id,
		  i.name,
		  i.unit,
		  i.default_amount,
		  i.kcal,
		  i.proteins,
		  i.fats,
		  i.carbs,
		  SUM(ia.amount) AS total_amount
		FROM diet_slots ds
		JOIN ingredient_amounts ia ON ia.dish_id = ds.dish_id
		JOIN ingredients i ON i.id = ia.ingredient_id
		WHERE ds.diet_id = $1
		  AND ds.slot_num = ANY($2)
		  AND i.shop_style IN ('Na żywo')
		GROUP BY i.id, i.name, i.unit, i.default_amount, i.kcal, i.proteins, i.fats, i.carbs
		ORDER BY i.name;
	`

	rows, err := s.db.QueryContext(ctx, q, dietID, pq.Array(slotNums))
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []model.IngredientInShoppingList
	for rows.Next() {
		var ing model.IngredientGetPut
		var amount float64

		err := rows.Scan(
			&ing.ID,
			&ing.Name,
			&ing.Unit,
			&ing.DefaultAmount,
			&ing.Kcal,
			&ing.Protein,
			&ing.Fat,
			&ing.Carbs,
			&amount,
		)
		if err != nil {
			return nil, err
		}

		ingMin := model.IngredientIdNameUnit{ID: ing.ID, Name: ing.Name, Unit: ing.Unit}

		result = append(result, model.IngredientInShoppingList{
			Ingredient: ingMin,
			Amount:     amount,
		})
	}

	return result, nil
}

func (s *ServiceShoppingList) getGSIngredients(ctx context.Context, dietID int, slotNums []int) ([]model.IngredientInShoppingList, error) {
	const q = `
		SELECT
		  i.id,
		  i.name,
		  i.unit,
		  i.default_amount,
		  i.kcal,
		  i.proteins,
		  i.fats,
		  i.carbs,
		  SUM(ia.amount) AS total_amount
		FROM diet_slots ds
		JOIN ingredient_amounts ia ON ia.dish_id = ds.dish_id
		JOIN ingredients i ON i.id = ia.ingredient_id
		WHERE ds.diet_id = $1
		  AND ds.slot_num = ANY($2)
		  AND i.shop_style IN ('G.S')
		GROUP BY i.id, i.name, i.unit, i.default_amount, i.kcal, i.proteins, i.fats, i.carbs
		ORDER BY i.name;
	`

	rows, err := s.db.QueryContext(ctx, q, dietID, pq.Array(slotNums))
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []model.IngredientInShoppingList
	for rows.Next() {
		var ing model.IngredientGetPut
		var amount float64

		err := rows.Scan(
			&ing.ID,
			&ing.Name,
			&ing.Unit,
			&ing.DefaultAmount,
			&ing.Kcal,
			&ing.Protein,
			&ing.Fat,
			&ing.Carbs,
			&amount,
		)
		if err != nil {
			return nil, err
		}

		ingMin := model.IngredientIdNameUnit{ID: ing.ID, Name: ing.Name, Unit: ing.Unit}

		result = append(result, model.IngredientInShoppingList{
			Ingredient: ingMin,
			Amount:     amount,
		})
	}

	return result, nil
}
