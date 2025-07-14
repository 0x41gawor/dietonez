import {ref, computed, onMounted} from 'vue'
import {useToast} from "vue-toastification";
import type {DishGet, DishGetShort, DishPost, DishPut} from '@/types/types'
import {getDishes, getDishById, createDish, updateDish, deleteDishById, updateDishName} from '@/api/dishes'

export function useDishViewLogic(id: number) {
  // ==== S T A T E ====
  const dish = ref<DishGet | null>(null)
  const isLoading = ref(true)
  const isAddingIngredient = ref(false)
  const hasPendingChanges = ref<boolean>(false)

  // helpers
  const toast = useToast()

  // ==== L I F E C Y C L E ====
  onMounted(fetchDish)

  // ==== M E T H O D S ====
  async function fetchDish() {
    console.log(id)
    try {
      isLoading.value = true
      const response = await getDishById(id)
      console.log("Fetched dish response:", response)
      dish.value = response
    } catch (error) {
      toast.error("Failed to fetch dish.")
    } finally {
      isLoading.value = false
    }
    console.log("Fetched dish:", dish.value)
  }

  // ==== H A N D L E R S ====
  const handleRevertButtonClick = () => {
    toast.info("Reverted all pending changes.")
    fetchDish()
  }

  const handleDeleteItem = async (ingredientId: number) => {
    // i want to delete the ingredient from the dish
    if (!dish.value) {
      toast.error("No dish to delete the ingredient from.")
      return
    } 

    console.log("Deleting ingredient with ID:", ingredientId)
    dish.value.ingredients = dish.value.ingredients.filter(item => item.ingredient.id !== ingredientId)
    hasPendingChanges.value = true
  }

  const handleUpdateButtonClick = async () => {
    // const changesToSubmit = Object.values(pendingChanges.value)

    // if (changesToSubmit.length === 0) {
    //   toast.warning("No changes to update.")
    //   return
    // }

    // try {
    //   await Promise.all(changesToSubmit.map(item => updateDish(dishId, item)))
    //   pendingChanges.value = {}
    //   toast.success("Changes updated successfully.")
    //   fetchDish()
    // } catch (error) {
    //   toast.error("Failed to update changes.")
    // }
  }

  return {
    dish,
    hasPendingChanges,
    handleDeleteItem,
    handleRevertButtonClick
  }
}