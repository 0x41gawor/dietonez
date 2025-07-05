package model

// SummaryResult holds the calculated macros.
type SummaryResult struct {
	Kcal     float64 `json:"kcal"`
	Proteins float64 `json:"proteins"`
	Fats     float64 `json:"fats"`
	Carbs    float64 `json:"carbs"`
}

type NutritionSummary struct {
	Kcal     float64 `json:"kcal"`
	Proteins float64 `json:"proteins"`
	Fats     float64 `json:"fats"`
	Carbs    float64 `json:"carbs"`
}

type DaySummaryRequest struct {
	Dishes []DishMinPut `json:"dishes"`
	Goal   float64      `json:"goal"`
}

type DaySummaryResponse struct {
	Summary Summary `json:"summary"`
	Left    Left    `json:"left"`
}
