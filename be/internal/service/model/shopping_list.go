package model

type IngredientInShoppingList struct {
	Ingredient IngredientIdNameUnit `json:"ingredient"`
	Amount     float64              `json:"amount"`
}

type ShoppingList struct {
	Fresh []IngredientInShoppingList `json:"fresh"`
	Lidl  []IngredientInShoppingList `json:"lidl"`
	Stock []IngredientInShoppingList `json:"stock"`
	Live  []IngredientInShoppingList `json:"live"`
	GS    []IngredientInShoppingList `json:"gs"`
}
