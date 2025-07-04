package service

import (
	"context"
	"database/sql"
	"fmt"

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
		total.Kcal += kcal * ratio
		total.Proteins += proteins * ratio
		total.Fats += fats * ratio
		total.Carbs += carbs * ratio
	}
	return total, nil
}
