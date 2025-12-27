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

type ingredientQueryConfig struct {
	shopStyles []string
	withPath   bool
	orderBy    string
}

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
	print("Shopping List - currentDate:", date.String()[:11], "\n")
	print("Shopping List - daysBetween:", daysBetween, "\n")
	print("Shopping List - currentDietDay:", currentDietDay, "\n")
	print("Shopping List - maxDietDay:", maxDietDay, "\n")

	freshSlotsRange := getFreshSlotsRange(currentDietDay, maxDietDay)
	lidlAndStockSlotsRange := getLidlAndStockSlotsRange(currentDietDay, maxDietDay)

	freshIngredients, err := s.getFreshIngredients(ctx, activeDietID, freshSlotsRange)
	if err != nil {
		return nil, fmt.Errorf("getFreshIngredients: %w", err)
	}
	stockIngredients, err := s.getStockIngredients(ctx)
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
		print("Fresh slot-range: [0..4]\n")
		return []int{0, 1, 2, 3, 4}
	}

	start := (currentDietDay + 1) * 5

	result := make([]int, 5)
	for i := range 5 {
		result[i] = start + i
	}
	fmt.Println("Fresh slot-range:", result)

	return result
}

// Lidl & Zapasy: zwraca ciąg 15‑slotowy lub pusty slice
func getLidlAndStockSlotsRange(currentDietDay, maxDietDay int) []int {
	if currentDietDay <= 0 {
		return []int{}
	}

	// Specjalny przypadek: dzień przed ostatnim (czyli ostatnia sobota)
	if currentDietDay == (maxDietDay - 1) {
		lastBreakfastSlot := maxDietDay * 5
		lastSunday := []int{lastBreakfastSlot, lastBreakfastSlot + 1, lastBreakfastSlot + 2, lastBreakfastSlot + 3, lastBreakfastSlot + 4}
		nextWeekSlots := []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
		fmt.Println(append(lastSunday, nextWeekSlots...))
		return append(lastSunday, nextWeekSlots...)
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
	result := make([]int, 0, 20)
	if posInWeek == 2 { // środa
		// czyli zakupy na czwartek-sobota (włącznie)
		start := weekNum*35 + 13
		for i := start; i < start+17; i++ {
			result = append(result, i)
		}
	} else { // sobota
		// czyli zakupy na niedziela-środa
		start := (weekNum+1)*35 - 5
		for i := start; i < start+18; i++ {
			result = append(result, i)
		}
	}
	fmt.Println("Lidl slot-range:", result)
	return result
}

func (s *ServiceShoppingList) getStockIngredients(ctx context.Context) ([]model.StockIngredientInShoppingList, error) {
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
		  i.is_present
		FROM ingredients i
		WHERE  i.shop_style IN ('Zapasy')
		ORDER BY i.is_present, i.name;
	`

	rows, err := s.db.QueryContext(ctx, q)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []model.StockIngredientInShoppingList
	for rows.Next() {
		var ing model.IngredientGetPut
		var isPresent bool

		err := rows.Scan(
			&ing.ID,
			&ing.Name,
			&ing.Unit,
			&ing.DefaultAmount,
			&ing.Kcal,
			&ing.Protein,
			&ing.Fat,
			&ing.Carbs,
			&isPresent,
		)
		if err != nil {
			return nil, err
		}

		ingMin := model.IngredientIdNameUnit{ID: ing.ID, Name: ing.Name, Unit: ing.Unit}

		result = append(result, model.StockIngredientInShoppingList{
			Ingredient: ingMin,
			Amount:     0,
			IsPresent:  isPresent,
		})
	}

	return result, nil
}

func (s *ServiceShoppingList) getIngredientsByConfig(
	ctx context.Context,
	dietID int,
	slotNums []int,
	cfg ingredientQueryConfig,
) ([]model.IngredientInShoppingList, error) {

	if len(slotNums) == 0 {
		return []model.IngredientInShoppingList{}, nil
	}

	selectPath := ""

	if cfg.withPath {
		selectPath = ", i.path"
	}

	q := fmt.Sprintf(`
		SELECT
		  i.id,
		  i.name,
		  i.unit,
		  i.default_amount,
		  i.kcal,
		  i.proteins,
		  i.fats,
		  i.carbs
		  %s,
		  SUM(ia.amount) AS total_amount
		FROM diet_slots ds
		JOIN ingredient_amounts ia ON ia.dish_id = ds.dish_id
		JOIN ingredients i ON i.id = ia.ingredient_id
		WHERE ds.diet_id = $1
		  AND ds.slot_num = ANY($2)
		  AND i.shop_style = ANY($3)
		GROUP BY i.id, i.name, i.unit, i.default_amount, i.kcal, i.proteins, i.fats, i.carbs
		ORDER BY %s;
	`, selectPath, cfg.orderBy)

	rows, err := s.db.QueryContext(
		ctx,
		q,
		dietID,
		pq.Array(slotNums),
		pq.Array(cfg.shopStyles),
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []model.IngredientInShoppingList

	for rows.Next() {
		var ing model.IngredientGetPut
		var amount float64

		if cfg.withPath {
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
		} else {
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
		}

		result = append(result, model.IngredientInShoppingList{
			Ingredient: model.IngredientIdNameUnit{
				ID:   ing.ID,
				Name: ing.Name,
				Unit: ing.Unit,
			},
			Amount: amount,
		})
	}

	return result, nil
}

func (s *ServiceShoppingList) getFreshIngredients(ctx context.Context, dietID int, slots []int) ([]model.IngredientInShoppingList, error) {
	return s.getIngredientsByConfig(ctx, dietID, slots, ingredientQueryConfig{
		shopStyles: []string{"Świeże"},
		orderBy:    "i.name",
	})
}

func (s *ServiceShoppingList) getLiveIngredients(ctx context.Context, dietID int, slots []int) ([]model.IngredientInShoppingList, error) {
	return s.getIngredientsByConfig(ctx, dietID, slots, ingredientQueryConfig{
		shopStyles: []string{"Na żywo"},
		orderBy:    "i.name",
	})
}

func (s *ServiceShoppingList) getGSIngredients(ctx context.Context, dietID int, slots []int) ([]model.IngredientInShoppingList, error) {
	return s.getIngredientsByConfig(ctx, dietID, slots, ingredientQueryConfig{
		shopStyles: []string{"G.S"},
		orderBy:    "i.name",
	})
}

func (s *ServiceShoppingList) getLidlIngredients(ctx context.Context, dietID int, slots []int) ([]model.IngredientInShoppingList, error) {
	return s.getIngredientsByConfig(ctx, dietID, slots, ingredientQueryConfig{
		shopStyles: []string{"Lidl"},
		withPath:   true,
		orderBy:    "i.path ASC, i.name ASC",
	})
}
