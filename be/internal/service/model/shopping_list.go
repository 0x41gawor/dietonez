package model

type IngredientInShoppingList struct {
	Ingredient IngredientMin `json:"ingredient"`
	Amount     float64       `json:"amount"`
}

type ShoppingList struct {
	Fresh *[]IngredientInShoppingList `json:"fresh"`
	Lidl  *[]IngredientInShoppingList `json:"lidl"`
	Stock *[]IngredientInShoppingList `json:"stock"`
}
