import {ref, computed, onMounted} from 'vue'
import {useToast} from "vue-toastification";
import type {DishGet, DishGetShort, DishPost, DishPut, IngredientInDishPut, IngredientGetPut, IngredientInDishGet} from '@/types/types'
import {getDishes, getDishById, createDish, updateDish, deleteDishById, updateDishName} from '@/api/dishes'
import { getIngredientById } from '@/api/ingredients';

export function useDishViewLogic(id: number) {
  // ==== S T A T E ====
  const dish = ref<DishGet>({
  id: 0,
  name: '',
  meal: 'Breakfast',
  kcal : 0,
  protein: 0,
  fat: 0,
  carbs: 0,
  ingredients: [],
  recipe: {total_time: '', before: '', when_to_start: '', preparation: ''},
  labels: [],
});
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

  if (!Array.isArray(dish.value.ingredients) || dish.value.ingredients.length === 0) {
    toast.error("Dish must contain at least one ingredient.");
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
    console.error("Update error:", error);
  }
};

const handleAddNewIngredient = async (newIngredient: IngredientInDishPut) => {
  console.log("Adding new ingredient:", newIngredient);

  let newIngredientInDish: IngredientInDishGet | null = null;

  try {
    const ingredientGetPut: IngredientGetPut = await getIngredientById(newIngredient.ingredient.id);
    newIngredientInDish = {
      ingredient: ingredientGetPut,
      amount: newIngredient.amount,
    };
  } catch (error) {
    toast.error("Failed to fetch ingredient details.");
    return; // ← ważne: przerwij, jeśli fetch się nie udał
  } finally {
    if (newIngredientInDish) {
      dish.value.ingredients.push(newIngredientInDish);
      hasPendingChanges.value = true;
      isAddingIngredient.value = false;
      toast.success("Ingredient added successfully.");
    }
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
    handleUpdateButtonClick,
    isAddingIngredient,
    handleAddNewIngredient,
  }
}