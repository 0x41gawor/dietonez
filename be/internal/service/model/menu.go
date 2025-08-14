package model

type Menu struct {
	Breakfast   DishGet     `json:"breakfast"`
	Lunch       DishGet     `json:"lunch"`
	PreWorkout  DishGet     `json:"preworkout"`
	PostWorkout DishGet     `json:"postworkout"`
	Supper      DishGet     `json:"supper"`
	Summary     MenuSummary `json:"menu_summary"`
}

type MenuSummary struct {
	Kcal         float64 `json:"kcal"`
	Proteins     float64 `json:"proteins"`
	Fats         float64 `json:"fats"`
	Carbs        float64 `json:"carbs"`
	KcalGoal     float64 `json:"kcal_goal"`
	ProteinPerKg float64 `json:"protein_per_kg"`
	FatsPerc     float64 `json:"fats_perc"`
	CarbsPerKg   float64 `json:"carbs_per_kg"`
}
