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

type UpsertCounterRecord struct {
	Day             string  `json:"day"`
	IngredientId    int64   `json:"ingredient_id"`
	OldIngredientId *int64  `json:"ingredient_id_old"`
	Meal            string  `json:"meal"`
	Amount          float64 `json:"amount"`
}

type UpsertDietSlotsCounterRecord struct {
	Day    string `json:"day"`
	Meal   string `json:"meal"`
	Name   string `json:"name"`
	DishID *int64 `json:"dishId"`
}

type DietSlotsCounterRecordIndex struct {
	Day  string `json:"day"`
	Meal string `json:"meal"`
}

type CopyDietSlotsCounterRecords struct {
	From DietSlotsCounterRecordIndex `json:"from"`
	To   DietSlotsCounterRecordIndex `json:"to"`
}
