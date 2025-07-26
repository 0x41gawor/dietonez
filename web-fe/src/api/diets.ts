import client from './client'
import type {
  DietShort,
  DietGet,
  DietPost,
  DietPut,
  DietContext,
  DietMin
} from '@/types/types'

// GET /diets
export async function getAllDiets(): Promise<DietShort[]> {
  const response = await client.get('/diets')
  return response.data
}

// GET /diets/{id}
export async function getDietById(id: number): Promise<DietGet> {
  const response = await client.get(`/diets/${id}`)
  return response.data
}

// POST /diets
export async function createDiet(diet: DietPost): Promise<DietGet> {
  const response = await client.post('/diets', diet)
  return response.data
}

// PUT /diets/{id}
export async function updateDietById(id: number, diet: DietPut): Promise<DietGet> {
  const response = await client.put(`/diets/${id}`, diet)
  return response.data
}

// DELETE /diets/{id}
export async function deleteDietById(id: number): Promise<void> {
  await client.delete(`/diets/${id}`)
}

// PATCH /diets/{id}/short
export async function updateDietShort(id: number, diet: DietShort): Promise<void> {
  await client.patch(`/diets/${id}/short`, diet)
}