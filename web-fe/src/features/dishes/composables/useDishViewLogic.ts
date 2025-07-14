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
    hasPendingChanges.value = false
    fetchDish()
  }

const handleUpdateButtonClick = async () => {
  if (!dish.value) {
    toast.error("No dish to update.");
    return;
  }

  try {
    const updatedDish: DishPut = {
      id: dish.value.id,
      name: dish.value.name,
      meal: dish.value.meal,
      recipe: dish.value.recipe,
      ingredients: dish.value.ingredients.map(item => ({
        ingredient: {
          id: item.ingredient.id,
          name: item.ingredient.name,
        },
        amount: item.amount,
      })),
    };

    await updateDish(dish.value.id, updatedDish);
    hasPendingChanges.value = false;
    toast.success("Dish updated successfully.");
  } catch (error) {
    toast.error("Failed to update dish.");
  }
};



  const handleDeleteItem = async (ingredientId: number) => {
    // i want to delete the ingredient from the dish
    if (!dish.value) {
      toast.error("No dish to delete the ingredient from.")
      return
    } 
    dish.value.ingredients = dish.value.ingredients.filter(item => item.ingredient.id !== ingredientId)
    hasPendingChanges.value = true
  }

  const handleUpdateItem = () => {
    // i want to update the ingredient in the dish
    if (!dish.value) {
      toast.error("No dish to update the ingredient in.")
      return
    }
    hasPendingChanges.value = true
  }
 
  return {
    dish,
    hasPendingChanges,
    handleDeleteItem,
    handleUpdateItem,
    handleRevertButtonClick,
    handleUpdateButtonClick
  }
}