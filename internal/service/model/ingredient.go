package model

type Ingredient struct {
	Id            int64   `json:"id"`
	Name          string  `json:"name"`
	DefaultAmount float64 `json:"defaultAmount"`
	Unit          string  `json:"unit"`
	ShopStyle     string  `json:"shopStyle"`
}
