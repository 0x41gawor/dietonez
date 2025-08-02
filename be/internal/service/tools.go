package service

import (
	"context"
	"database/sql"
	"fmt"
	"math"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceTools struct {
	db *sql.DB
}

func NewServiceTools() *ServiceTools {
	db := repo.GetDatabaseInstance().DB
	return &ServiceTools{db: db}
}
func (s *ServiceTools) CaclucateIngredientSummary(ctx context.Context, input model.IngredientInDishPut) (model.NutritionSummary, error) {
	var total model.NutritionSummary

	var kcal, proteins, fats, carbs, default_amount float64
	err := s.db.QueryRowContext(ctx, `
		SELECT kcal, proteins, fats, carbs, default_amount
		FROM ingredients
		WHERE id = $1
	`, input.Ingredient.ID).Scan(&kcal, &proteins, &fats, &carbs, &default_amount)

	if err != nil {
		return model.NutritionSummary{}, fmt.Errorf("ingredient ID %d not found: %w", input.Ingredient.ID, err)
	}

	ratio := input.Amount / default_amount
	total.Kcal = round1(kcal * ratio)
	total.Proteins = round1(proteins * ratio)
	total.Fats = round1(fats * ratio)
	total.Carbs = round1(carbs * ratio)

	return total, nil
}

func round1(f float64) float64 {
	return math.Round(f*10) / 10
}

// Implementation in service/service.go
func (s *ServiceTools) CalculateSummary(ctx context.Context, list []model.IngredientInDishPut) (model.NutritionSummary, error) {
	var total model.NutritionSummary

	for _, entry := range list {
		var kcal, proteins, fats, carbs, default_amount float64

		err := s.db.QueryRowContext(ctx, `
			SELECT kcal, proteins, fats, carbs, default_amount
			FROM ingredients
			WHERE id = $1
		`, entry.Ingredient.ID).Scan(&kcal, &proteins, &fats, &carbs, &default_amount)

		if err != nil {
			return model.NutritionSummary{}, fmt.Errorf("ingredient ID %d not found: %w", entry.Ingredient.ID, err)
		}

		ratio := entry.Amount / default_amount
		total.Kcal += round1(kcal * ratio)
		total.Proteins += round1(proteins * ratio)
		total.Fats += round1(fats * ratio)
		total.Carbs += round1(carbs * ratio)
	}
	return total, nil
}

func (s *ServiceTools) CalculateDaySummary(ctx context.Context, dishes []model.DishMinPut, goal float64) (model.DaySummaryResponse, error) {
	var allIngredients []model.IngredientInDishPut

	for _, dish := range dishes {
		if dish.ID == 0 {
			continue // obsługa pustych/nullowych pozycji
		}

		rows, err := s.db.QueryContext(ctx, `
			SELECT ingredient_id, amount
			FROM ingredient_amounts
			WHERE dish_id = $1
		`, dish.ID)
		if err != nil {
			return model.DaySummaryResponse{}, fmt.Errorf("fetching ingredients for dish %d: %w", dish.ID, err)
		}
		defer rows.Close()

		for rows.Next() {
			var ingID int
			var amount float64
			if err := rows.Scan(&ingID, &amount); err != nil {
				return model.DaySummaryResponse{}, fmt.Errorf("scanning ingredient: %w", err)
			}
			allIngredients = append(allIngredients, model.IngredientInDishPut{
				Ingredient: model.IngredientMin{ID: ingID},
				Amount:     amount,
			})
		}
	}

	summary, err := s.CalculateSummary(ctx, allIngredients)
	if err != nil {
		return model.DaySummaryResponse{}, fmt.Errorf("summary calc error: %w", err)
	}

	// Pobierz wagę użytkownika z diet_context (zakładam 1 aktywny kontekst)
	var weight float64
	err = s.db.QueryRowContext(ctx, `
		SELECT current_weight
		FROM diet_contexts
		LIMIT 1
	`).Scan(&weight)
	if err != nil {
		return model.DaySummaryResponse{}, fmt.Errorf("fetching weight from diet_contexts: %w", err)
	}

	// Obliczenia końcowe
	left := model.Left{
		Kcal:     goal - summary.Kcal,
		Proteins: summary.Proteins / weight,
		Fats:     (summary.Fats * 9 / summary.Kcal) * 100, // % kcal z tłuszczu
	}

	resp := model.DaySummaryResponse{
		Summary: model.Summary{
			Goal:     goal,
			Kcal:     summary.Kcal,
			Proteins: summary.Proteins,
			Fats:     summary.Fats,
			Carbs:    summary.Carbs,
		},
		Left: left,
	}

	return resp, nil
}

func (s *ServiceTools) CalculateDaySummaryFromSlots(ctx context.Context, slots []model.SlotGet, goal float64) (model.Summary, error) {
	var summary model.Summary

	for _, slot := range slots {
		if slot.Dish == nil {
			continue // pomiń puste sloty
		}
		summary.Kcal += slot.Dish.Kcal
		summary.Proteins += slot.Dish.Protein
		summary.Fats += slot.Dish.Fat
		summary.Carbs += slot.Dish.Carbs
	}

	summary.Goal = goal

	return summary, nil
}

func (s *ServiceTools) CalculateDayLeftFromSlots(ctx context.Context, slots []model.SlotGet, goal float64) (model.Left, error) {
	var left model.Left
	var sumKcal float64 = 0.0
	var sumProt float64 = 0.0
	var sumFat float64 = 0.0

	for _, slot := range slots {
		if slot.Dish == nil {
			continue // pomiń puste sloty
		}
		sumKcal += slot.Dish.Kcal
		sumProt += slot.Dish.Protein
		sumFat += slot.Dish.Fat
	}

	// Get current weight
	const qQuery = `
	SELECT current_weight from diet_context
	`
	var currentWeight float64
	err := s.db.QueryRowContext(ctx, qQuery).Scan(&currentWeight)
	if err != nil {
		return model.Left{}, fmt.Errorf("query current weight: %w", err)
	}

	left.Kcal = goal - sumKcal
	fmt.Print("Kcal: ", left.Kcal)
	left.Proteins = sumProt / currentWeight
	fmt.Print("Prots: ", left.Proteins)
	left.Fats = sumFat * 9 / sumKcal
	fmt.Print("Fats: ", left.Fats)
	// KCAL: calculate overall kcal and substract it from goal

	// PROTEINS: calculate overall proteins and divide it by currentWeight

	// FATS: calculate overall fats, multiply it by 9 and divide by overall kcal
	return left, nil
}
