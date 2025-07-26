import client from './client'
import type {
  DietShort,
  DietGet,
  DietPost,
  DietPut,
  DietContext,
  DietMin,
  DietContextGet,
  DietContextPut,
} from '@/types/types'

// GET /diet-contexte
export async function getDietContext(): Promise<DietContextGet> {
  const response = await client.get('/diet-context')
  return response.data
}

// PUT /diet-context
export async function updateDietContext(context: DietContextPut): Promise<DietContextGet> {
  const response = await client.put('/diet-context', context)
  return response.data
}


// GET /diets
export async function getDietMins(): Promise<DietMin[]> {
  const response = await client.get('/diets?min=true')
  return response.data
}