package model

type CounterRecord struct {
	Day          string  `json:"day"`
	IngredientId int64   `json:"ingredient_id"`
	Meal         string  `json:"meal"`
	Amount       float64 `json:"amount"`
}

type CounterRecordIndex struct {
	Day          string `json:"day"`
	IngredientId int64  `json:"ingredient_id"`
	Meal         string `json:"meal"`
}
