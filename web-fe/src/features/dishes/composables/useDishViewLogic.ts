import {ref, computed, onMounted, Ref, watch} from 'vue'
import {useToast} from "vue-toastification";
import { useRouter } from 'vue-router'
import type {DishGet, NutritionSummary, DishPut, IngredientInDishPut, IngredientGetPut, IngredientInDishGet, Meal} from '@/types/types'
import {getDishes, getDishById, createDish, updateDish, deleteDishById, updateDishName} from '@/api/dishes'
import { getIngredientById } from '@/api/ingredients';

export function useDishViewLogic(id: Ref<number>, initialMeal: Meal) {
  // ==== S T A T E ====
  const dish = ref<DishGet>({
  id: 0,
  name: '',
  meal: initialMeal, // ← kluczowe
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
  const showDeleteModal = ref(false)
  const isCreatingNew = computed(() => id.value === 0);

const round1 = (v: number) => Math.round(v * 10) / 10;

const summary = computed<NutritionSummary>(() => ({
  kcal: round1(dish.value.kcal),
  proteins: round1(dish.value.protein),
  fats: round1(dish.value.fat),
  carbs: round1(dish.value.carbs),
}));


  // helpers
  const toast = useToast()

  // ==== L I F E C Y C L E ====
watch(
  id,
  async (newId) => {
    if (newId > 0) {
      await fetchDish();
    }
  },
  { immediate: true }
)



  // ==== M E T H O D S ====
  async function fetchDish() {
    console.log(id)
    try {
      isLoading.value = true
      const response = await getDishById(id.value)
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
  fetchDish();
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
      dish.value.kcal += (newIngredientInDish.ingredient.kcal ?? 0) * newIngredientInDish.amount / (newIngredientInDish.ingredient.default_amount ?? 1);
      dish.value.protein += (newIngredientInDish.ingredient.protein ?? 0) * newIngredientInDish.amount / (newIngredientInDish.ingredient.default_amount ?? 1);
      dish.value.fat += (newIngredientInDish.ingredient.fat ?? 0) * newIngredientInDish.amount / (newIngredientInDish.ingredient.default_amount ?? 1);
      dish.value.carbs += (newIngredientInDish.ingredient.carbs ?? 0) * newIngredientInDish.amount / (newIngredientInDish.ingredient.default_amount ?? 1);
      hasPendingChanges.value = true;
      isAddingIngredient.value = false;
      toast.success("Ingredient added successfully.");
    }
  }
};



  const handleDeleteItem = async (ingredientId: number) => {
    if (!dish.value) {
      toast.error("No dish to delete the ingredient from.")
      return
    } 
    dish.value.ingredients = dish.value.ingredients.filter(item => item.ingredient.id !== ingredientId)
    hasPendingChanges.value = true
  }

  const handleUpdateItem = () => {
    if (!dish.value) {
      toast.error("No dish to update the ingredient in.")
      return
    }
    hasPendingChanges.value = true
  }

const handleDeleteButtonClick = () => {
  showDeleteModal.value = true
}

const router = useRouter()

const confirmDelete = async () => {
  try {
    await deleteDishById(dish.value.id)
    toast.success("Dish deleted.")
    router.back() // albo router.push('/dishes') jeśli masz stały path
  } catch (err) {
    toast.error("Failed to delete dish.")
    console.error(err)
  } finally {
    showDeleteModal.value = false
  }
}

const handleCreateButtonClick = async () => {
  try {
    const newDish: DishPut = {
      id: 0,
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

    const createdDish = await createDish(newDish);
    toast.success("Dish created.");

    // fetchujemy pełne dane i przestawiamy widok
    router.push(`/dishes/${dish.value.meal}/${createdDish.id}/edit`);
  } catch (err) {
    toast.error("Failed to create dish.");
    console.error(err);
  }
}

 
  return {
    dish,
    summary,
    hasPendingChanges,
    handleDeleteItem,
    handleUpdateItem,
    handleRevertButtonClick,
    handleUpdateButtonClick,
    handleCreateButtonClick,
    handleDeleteButtonClick,
    isAddingIngredient,
    handleAddNewIngredient,
    confirmDelete,
    showDeleteModal,
    isCreatingNew,
  }
}