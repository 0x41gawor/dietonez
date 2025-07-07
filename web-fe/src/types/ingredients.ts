import { IngredientGetPut } from "./types"

export interface IngredientResponse {
  total: number
  ingredients: IngredientGetPut[]
}
