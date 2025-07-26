package model

type Menu struct {
	Breakfast   DishGet `json:"breakfast"`
	Lunch       DishGet `json:"lunch"`
	PreWorkout  DishGet `json:"preworkout"`
	PostWorkout DishGet `json:"postworkout"`
	Supper      DishGet `json:"supper"`
}
