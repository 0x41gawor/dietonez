import client from './client'
import type { IngredientResponse } from '@/types/ingredients'

interface GetIngredientsParams {
  page?: number
  pageSize?: number
  short?: boolean
}

export async function getIngredients(params: GetIngredientsParams = {}): Promise<IngredientResponse> {
  const response = await client.get('/ingredients', { params })
  return response.data
}
