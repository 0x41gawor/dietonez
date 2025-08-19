package model

type Menu struct {
	Breakfast   DishInMenu  `json:"breakfast"`
	Lunch       DishInMenu  `json:"lunch"`
	PreWorkout  DishInMenu  `json:"preworkout"`
	PostWorkout DishInMenu  `json:"postworkout"`
	Supper      DishInMenu  `json:"supper"`
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
