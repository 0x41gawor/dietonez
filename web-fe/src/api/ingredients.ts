import client from './client'
import type { IngredientGetPut, IngredientPost, PaginatedIngredients} from '@/types/types'

export interface GetIngredientsParams {
  page?: number
  pageSize?: number
  short?: boolean
}

export interface SearchIngredientsParams {
  query?: string
  reslen?: number
}

export async function getIngredients(params: GetIngredientsParams = {}): Promise<PaginatedIngredients>{
  const response = await client.get('/ingredients', { params })
  return response.data
}

export async function searchIngredients(params: SearchIngredientsParams = {}): Promise<PaginatedIngredients>{
  const response = await client.get('/ingredients/search', { params })
  return response.data
}

export async function getIngredientById(id: number): Promise<IngredientGetPut> {
  const response = await client.get(`/ingredients/${id}`);
  return response.data;
}

export async function updateIngredients(ingredients: IngredientGetPut[]): Promise<{ updated: number }> {
  const response = await client.put('/ingredients/bulk', ingredients)
  return response.data
}

export async function deleteIngredientById(id: number): Promise<void> {
  await client.delete(`/ingredients/${id}`);
}

export async function createIngredient(ingredient: IngredientPost): Promise<{ id: number}> {
  const response  = await client.post('/ingredients', ingredient);
  return response.data;
}