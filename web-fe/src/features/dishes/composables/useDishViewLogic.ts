import {ref, computed, onMounted} from 'vue'
import {useToast} from "vue-toastification";
import type {DishGet, DishGetShort, DishPost, DishPut} from '@/types/types'
import {getDishes, getDishById, createDish, updateDish, deleteDishById, updateDishName} from '@/api/dishes'

export function useDishViewLogic(dishId: number) {
  // ==== S T A T E ====
  const dish = ref<DishPut | null>(null)
  const isLoading = ref(true)
  const isAddingIngredient = ref(false)
  const pendingChanges = ref<Record<number, DishGetShort>>({})
  const hasPendingChanges = computed(() => Object.keys(pendingChanges.value).length > 0)

  // helpers
  const toast = useToast()

  // ==== L I F E C Y C L E ====
  onMounted(fetchDish)

  // ==== M E T H O D S ====
  async function fetchDish() {
    try {
      isLoading.value = true
      dish.value = await getDishById(dishId)
    } catch (error) {
      toast.error("Failed to fetch dish.")
    } finally {
      isLoading.value = false
    }
  }

  // ==== H A N D L E R S ====
  const handleRevertButtonClick = () => {
    pendingChanges.value = {}
    toast.info("Reverted all pending changes.")
    fetchDish()
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
    dish
  }
}