import client from './client'
import type { IngredientResponse } from '@/types/ingredients'
import type { IngredientGetPut } from '@/types/types'

interface GetIngredientsParams {
  page?: number
  pageSize?: number
  short?: boolean
}

export async function getIngredients(params: GetIngredientsParams = {}): Promise<IngredientResponse> {
  const response = await client.get('/ingredients', { params })
  return response.data
}

export async function updateIngredients(ingredients: IngredientGetPut[]): Promise<{ updated: number }> {
  const response = await client.put('/ingredients', ingredients)
  return response.data
}
