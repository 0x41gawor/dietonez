package model

type IngredientInShoppingList struct {
	Ingredient IngredientIdNameUnit `json:"ingredient"`
	Amount     float64              `json:"amount"`
}

type StockIngredientInShoppingList struct {
	Ingredient IngredientIdNameUnit `json:"ingredient"`
	Amount     float64              `json:"amount"`
	IsPresent  bool                 `json:"is_present"`
}

type ShoppingList struct {
	Fresh []IngredientInShoppingList      `json:"fresh"`
	Lidl  []IngredientInShoppingList      `json:"lidl"`
	Stock []StockIngredientInShoppingList `json:"stock"`
	Live  []IngredientInShoppingList      `json:"live"`
	GS    []IngredientInShoppingList      `json:"gs"`
}
