import { ref, computed, onMounted } from 'vue';
import { useToast } from "vue-toastification";
import { IngredientGetPut, IngredientPost } from '@/types/types';
import { getIngredients, updateIngredients, deleteIngredientById, createIngredient } from '@/api/ingredients'

export function useIngredientsLogic() {
  // ==== S T A T E ====
  const ingredients = ref<IngredientGetPut[]>([])
  const total = ref(0)
  const page = ref(1)
  const pageSize = ref(100)
  const totalPages = ref(1)
  const pendingChanges = ref<Record<number, IngredientGetPut>>({})
  const pendingDeletes = ref<Set<number>>(new Set())
  const isAddingIngredient = ref(false)
  const searchText = ref('')
  const hasPendingChanges = computed(() => {
    return Object.keys(pendingChanges.value).length > 0 || pendingDeletes.value.size > 0
  })
  // helpers 
  const toast = useToast()
  // ==== L I F E C Y C L E ==== 
  onMounted(fetchIngredients)
  // ==== M E T H O D S ====
  // == A P I  C A L L S ====
  async function fetchIngredients() {
    const response = await getIngredients({ page: page.value, pageSize: pageSize.value })
    ingredients.value = response.ingredients
    total.value = response.total
    totalPages.value = Math.ceil(total.value / pageSize.value)
  }
  // ==== H A N D L E R S ====
  // Called by child table when an item is edited
  // Updates the item in the local state and marks it as pending
  const handleItemUpdate = (updatedItem: IngredientGetPut) => {
    const index = ingredients.value.findIndex(item => item.id === updatedItem.id)
    if (index !== -1) {
      ingredients.value[index] = updatedItem
      pendingChanges.value[updatedItem.id] = updatedItem
    }
  }
  // Called when the user clicks the revert button
  // Reverts all pending changes and clears both pendingChanges and pendingDeletes
  const handleRevertButtonClick = () => {
    pendingChanges.value = {}
    pendingDeletes.value.clear()
    toast.info("Reverted all pending changes.")
    fetchIngredients()
  }
  // Called when the user clicks the update button
  // Submits all pending changes and clears both pendingChanges and pendingDeletes
  const handleUpdateButtonClick = async () => {
    const changesToSubmit = Object.values(pendingChanges.value)

    if (changesToSubmit.length === 0 && pendingDeletes.value.size === 0) {
      toast.warning("No changes to update.")
      return
    }

    try {
      if (changesToSubmit.length > 0) {
        const response = await updateIngredients(changesToSubmit)
        toast.success(`${response.updated} ingredient(s) successfully updated!`)
      }

      for (const id of pendingDeletes.value) {
        try {
          await deleteIngredientById(id)
          toast.success(`Deleted ingredient ${id}`)
        } catch (err) {
          toast.error(`Failed to delete item ID ${id}`)
        }
      }

      pendingChanges.value = {}
      pendingDeletes.value.clear()
      fetchIngredients()

    } catch (error) {
      toast.error("Failed to update ingredients. Please try again.")
    }
  }
  // Called when the user clicks the delete button
  // Removes the item from the local state and adds it to pendingDeletes
  const handleDeleteItem = (idToDelete: number) => {
    ingredients.value = ingredients.value.filter(item => item.id !== idToDelete)
    pendingDeletes.value.add(idToDelete)
  }
  // Called when the user submits a new ingredient
  // Adds the new ingredient to the local state and triggers an API call to create it
  // Here we have no any pending mechanism and API is called immediately
  const handleAddNewIngredient = async (newIngredient: IngredientPost) => {
    isAddingIngredient.value = true
    try {
      const response = await createIngredient(newIngredient)
      toast.success(`Ingredient ${response.id} successfully added!`)
    } catch (error) {
      toast.error("Failed to add ingredient.")
    } finally {
      isAddingIngredient.value = false
      fetchIngredients()
    }
  }
  // Called by the child table when the user changes the page size
  // Updates the pageSize and fetches the ingredients again
  const handlePageSizeUpdate = (newSize: number) => {
    pageSize.value = newSize
    fetchIngredients()
  }
  // Called by the child table when the user changes the page
  // Updates the page and fetches the ingredients again
  const handlePageChange = (direction: number) => {
    page.value += direction
    if (page.value < 1) page.value = 1
    if (page.value > totalPages.value) page.value = totalPages.value
    fetchIngredients()
  }
  // ==== R E T U R N ====
  // Expose the state and methods to the component
  return {
    ingredients,
    total,
    page,
    pageSize,
    totalPages,
    isAddingIngredient,
    searchText,
    hasPendingChanges,
    handleItemUpdate,
    handleRevertButtonClick,
    handleUpdateButtonClick,
    handleDeleteItem,
    handleAddNewIngredient,
    handlePageSizeUpdate,
    handlePageChange
  }
}
