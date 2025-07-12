import client from './client'
import type {
  DishGet,
  DishGetShort,
  DishPost,
  DishPut
} from '@/types/types'

interface GetDishesParams {
  meal: 'Breakfast' | 'MainMeal' | 'Pre-Workout' | 'Supper'
  min?: boolean
}

export async function getDishes(params: GetDishesParams): Promise<DishGetShort[]> {
  const response = await client.get('/dishes', { params })
  return response.data
}

export async function getDishById(id: number): Promise<DishGet> {
  const response = await client.get(`/dishes/${id}`)
  return response.data
}

export async function createDish(dish: DishPost): Promise<DishGet> {
  const response = await client.post('/dishes', dish)
  return response.data
}

export async function updateDish(id: number, dish: DishPut): Promise<DishGet> {
  const response = await client.put(`/dishes/${id}`, dish)
  return response.data
}

export async function deleteDishById(id: number): Promise<void> {
  await client.delete(`/dishes/${id}`)
}

export async function updateDishName(id: number, name: string): Promise<void> {
  await client.patch(`/dishes/${id}/name`, { name });
}