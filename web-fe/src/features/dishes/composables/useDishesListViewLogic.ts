import { ref, computed, onMounted } from 'vue';
import { useToast } from "vue-toastification";
import type {
  DishGet,
  DishGetShort,
  DishPost,
  DishPut
} from '@/types/types'
import { getDishes, getDishById, createDish, updateDish, deleteDishById, updateDishName } from '@/api/dishes'

export function useDishesListViewLogic(meal: 'Breakfast' | 'MainMeal' | 'Pre-Workout' | 'Supper') {
    // ==== S T A T E ====
    const dishes = ref<DishGetShort[]>([])
    const total = ref(0)
    const page = ref(1)
    const pageSize = ref(100)
    const totalPages = ref(1)
    const pendingChanges = ref<Record<number, DishGetShort>>({})
    const isAddingDish = ref(false)
    const searchText = ref('')
    const hasPendingChanges = computed(() => {
        return Object.keys(pendingChanges.value).length > 0
    })
    // helpers
    const toast = useToast()
    // ==== L I F E C Y C L E ====
    onMounted(fetchDishes)
    // ==== M E T H O D S ====
    // == A P I  C A L L S ====
    async function fetchDishes() {
        const response = await getDishes({ meal: meal, min: false })
        dishes.value = response
        total.value = response.length
        totalPages.value = Math.ceil(total.value / pageSize.value)
    }
    // ==== H A N D L E R S ====
    // Called by child table when an item is edited
    // Updates the item in the local state and marks it as pending
    const handleItemUpdate = (updatedItem: DishGetShort) => {
        const index = dishes.value.findIndex(item => item.id === updatedItem.id)
        if (index !== -1) {
            dishes.value[index] = updatedItem
            pendingChanges.value[updatedItem.id] = updatedItem
        }
    }
    // Called when the user clicks the revert button
    // Reverts all pending changes and clears both pendingChanges and pendingDeletes
    const handleRevertButtonClick = () => {
        pendingChanges.value = {}
        toast.info("Reverted all pending changes.")
        fetchDishes()
    }
    // Called when the user clicks the update button
    // Submits all pending changes and clears pendingChanges
    const handleUpdateButtonClick = async () => {
        const changesToSubmit = Object.values(pendingChanges.value)

        if (changesToSubmit.length === 0) {
            toast.warning("No changes to update.")
            return
        }

        try {
            for (const change of changesToSubmit) {
                await updateDishName(change.id, change.name)
            }
            pendingChanges.value = {}
            toast.success("Dishes updated successfully.")
            fetchDishes()
        } catch (error) {
            toast.error("Failed to update dishes.")
        }
    }
    // Called by the child table when the user changes the page size
    // Updates the pageSize and fetches the ingredients again
    const handlePageSizeUpdate = (newSize: number) => {
        pageSize.value = newSize
        console.log('Page size updated to:', pageSize.value)
        fetchDishes()
    }
    // Called by the child table when the user changes the page
    // Updates the page and fetches the ingredients again
    const handlePageChange = (direction: number) => {
        page.value += direction
        if (page.value < 1) page.value = 1
        if (page.value > totalPages.value) page.value = totalPages.value
        fetchDishes()
    }
    // Called when the user clicks the Add button
    const handleAddButtonClick = () => {
        console.log('Add button clicked');
    }
    // ==== R E T U R N ====
    return {
        dishes,
        total,
        page,
        pageSize,
        totalPages,
        pendingChanges,
        isAddingDish,
        searchText,
        hasPendingChanges,
        fetchDishes,
        handleItemUpdate,
        handleRevertButtonClick,
        handleUpdateButtonClick,
        handlePageSizeUpdate,
        handlePageChange,
        handleAddButtonClick
    }
}