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

	// Obliczenie różnicy dni (startDate → date) +1
	daysBetween := int(date.Sub(startDate).Hours()/24) + 1
	if daysBetween <= 0 {
		return nil, fmt.Errorf("current date is before start date")
	}

	maxDietDay := maxSlotNum / 30 * 7
	currentDietDay := daysBetween % maxDietDay

	freshSlotsRange := getFreshSlotsRange(currentDietDay, maxDietDay)
	lidlAndStockSlotsRange := getLidlAndStockSlotsRange(currentDietDay, maxDietDay)

	freshIngredients, err := s.getFreshIngredients(ctx, activeDietID, freshSlotsRange)
	if err != nil {
		return nil, fmt.Errorf("getFreshIngredients")
	}
	stockIngredients, err := s.getStockIngredients(ctx, activeDietID, lidlAndStockSlotsRange)
	if err != nil {
		return nil, fmt.Errorf("getStockIngredients")
	}
	lidlIngredients, err := s.getLidlIngredients(ctx, activeDietID, lidlAndStockSlotsRange)
	if err != nil {
		return nil, fmt.Errorf("getLidlIngredients")
	}
	result := &model.ShoppingList{
		Fresh: freshIngredients,
		Lidl:  lidlIngredients,
		Stock: stockIngredients,
	}

	return result, nil
}

func getFreshSlotsRange(currentDietDay, maxDietDay int) []int {
	if currentDietDay <= 0 {
		return []int{}
	}

	// Specjalny przypadek: ostatni dzień całej diety
	if currentDietDay == maxDietDay {
		return []int{1, 2, 3, 4, 5}
	}

	posInWeek := (currentDietDay - 1) % 7

	// Sobota (6‑ty dzień licząc od poniedziałku = 0) → brak slotów
	if posInWeek == 5 {
		return []int{}
	}

	weekNum := (currentDietDay - 1) / 7

	// Offset w tygodniu z korektą na brak soboty
	var posOffset int
	if posInWeek < 5 { // pon–pt
		posOffset = posInWeek
	} else { // niedziela
		posOffset = 5
	}

	// Globalny indeks „slotowego” dnia
	index := weekNum*6 + posOffset

	start := 6 + index*5

	return []int{start, start + 1, start + 2, start + 3, start + 4}
}

// Lidl & Zapasy: zwraca ciąg 15‑slotowy lub pusty slice
func getLidlAndStockSlotsRange(currentDietDay, maxDietDay int) []int {
	if currentDietDay <= 0 {
		return []int{}
	}

	// Specjalny przypadek: dzień przed ostatnim
	if currentDietDay == maxDietDay-1 {
		return []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
	}

	// Niedopuszczamy ostatniego dnia (maxDay) – ma być pusty
	if currentDietDay >= maxDietDay {
		return []int{}
	}

	posInWeek := (currentDietDay - 1) % 7
	if posInWeek != 2 && posInWeek != 5 { // nie środa i nie sobota → brak slotów
		return []int{}
	}

	weekNum := (currentDietDay - 1) / 7 // ile pełnych tygodni minęło
	// Która to „slotowa” pozycja w całym harmonogramie:
	// - w każdym tygodniu są dokładnie 2 slotowe dni (śr = indeks 0, sob = indeks 1)
	var withinWeekIndex int
	if posInWeek == 2 { // środa
		withinWeekIndex = 0
	} else { // sobota
		withinWeekIndex = 1
	}
	rangeIndex := weekNum*2 + withinWeekIndex

	start := 16 + rangeIndex*15 // 16, 31, 46, 61, 76, ...

	result := make([]int, 15)
	for i := 0; i < 15; i++ {
		result[i] = start + i
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

		ingMin := model.IngredientMin{ID: ing.ID, Name: ing.Name}

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
		  SUM(ia.amount) AS total_amount
		FROM diet_slots ds
		JOIN ingredient_amounts ia ON ia.dish_id = ds.dish_id
		JOIN ingredients i ON i.id = ia.ingredient_id
		WHERE ds.diet_id = $1
		  AND ds.slot_num = ANY($2)
		  AND i.shop_style IN ('Lidl')
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

		ingMin := model.IngredientMin{ID: ing.ID, Name: ing.Name}

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

		ingMin := model.IngredientMin{ID: ing.ID, Name: ing.Name}

		result = append(result, model.IngredientInShoppingList{
			Ingredient: ingMin,
			Amount:     amount,
		})
	}

	return result, nil
}
