<template>
  <section>
    <div class="header">
      <SearchBar
        v-model="searchText"
        placeholder="Search ingredients..."
      />
      <div class="buttons">
        <RevertButton 
          @click="handleRevertButtonClick"
          :disabled="!hasPendingChanges" 
        /> 
        <UpdateButton 
          @click="handleUpdateBUttonClick"
          :disabled="!hasPendingChanges" 
        />
      </div>
    </div>

    <IngredientTable 
      :ingredients="ingredients"
      :current-page="1"
      :total-pages="totalPages"
      :page-size="pageSize"
      :page="page"
      :total="total"
      @delete-item="handleDeleteItem"
      @item-updated="handleItemUpdate"
      @pageSizeChanged="handlePageSizeUpdate"
      @pageChanged="handlePageChange"
    />

     <AddRowSection
      :loading="isAddingIngredient"
      @add-ingredient="handleAddNewIngredient"
    />
  </section>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useToast } from "vue-toastification";
import { onMounted, ref, watch } from 'vue'
import IngredientTable from '../components/IngredientTable.vue';
import AddRowSection from '../components/AddRowSection.vue';
import SearchBar from '@/components/SearchBar.vue';
import RevertButton from '@/components/RevertButton.vue';
import UpdateButton from '@/components/UpdateButton.vue';
import { IngredientGetPut } from '@/types/types';
import { getIngredients, updateIngredients, deleteIngredientById, createIngredient } from '@/api/ingredients'

const ingredients = ref<IngredientGetPut[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = ref(100)
const totalPages = ref(1)
const toast = useToast();
const pendingChanges = ref<Record<number, IngredientGetPut>>({});
const pendingDeletes = ref<Set<number>>(new Set());
  // This state will control the loading prop
const isAddingIngredient = ref(false);


async function fetchIngredients() {
  const result = await getIngredients({ page: page.value, pageSize: pageSize.value })
  ingredients.value = result.ingredients
  total.value = result.total
  totalPages.value = Math.ceil(total.value / pageSize.value)
}

// fetch on load
onMounted(fetchIngredients)

// (optional) react to page change
watch([page, pageSize], fetchIngredients)

// 4. State Management: The parent component now holds the data
const searchText = ref('');

// This will be true if there are any items waiting to be saved.
// We'll use this to enable/disable the Revert and Update buttons.
const hasPendingChanges = computed(() => {
  return (
    Object.keys(pendingChanges.value).length > 0 ||
    pendingDeletes.value.size > 0
  );
});

// NEW: Handler for the real-time update event from the child table
const handleItemUpdate = (updatedItem: IngredientGetPut) => {
  console.log('An item was staged for update:', updatedItem);

  // Find the index of the item in the master list
  const index = ingredients.value.findIndex(item => item.id === updatedItem.id);
  
  // If found, update the item in the master list
  if (index !== -1) {
    // IMPORTANT: Replace the entire object to ensure reactivity.
    ingredients.value[index] = updatedItem;
    
    // At this point, you could also trigger an auto-save to your backend API.
    pendingChanges.value[updatedItem.id] = updatedItem;
  }
};

const handleRevertButtonClick = () => {
  // This function will be called when the RevertButton is clicked
  console.log('Revert button clicked, fetching ingredients again...');
  // Clear any changes that were waiting to be saved
  pendingChanges.value = {};
  pendingDeletes.value.clear();
  
  // Inform the user
  toast.info("Reverted all pending changes.");
  fetchIngredients();
};

// When the "Update" button is clicked
const handleUpdateBUttonClick = async () => {
  const changesToSubmit = Object.values(pendingChanges.value);

  if (changesToSubmit.length === 0 && pendingDeletes.value.size === 0) {
    toast.warning("No changes to update.");
    return;
  }

  try {
    if (changesToSubmit.length > 0) {
      const response = await updateIngredients(changesToSubmit);
      toast.success(`${response.updated} ingredient(s) successfully updated!`);
    }

    for (const id of pendingDeletes.value) {
      try {
        await deleteIngredientById(id);
      } catch (err) {
        console.error(`Failed to delete ingredient ${id}`, err);
        toast.error(`Failed to delete item ID ${id}`);
      }
      finally {
        console.log(`Deleted ingredient ${id}`);
        toast.success(`Deleted ingredient  ${id}`);
      }
    }

    // Wyczyść pending states
    pendingChanges.value = {};
    pendingDeletes.value.clear();

    // Odśwież dane
    fetchIngredients();

  } catch (error) {
    console.error("Failed to update ingredients:", error);
    toast.error("Failed to update ingredients. Please try again.");
  }
};
const handleDeleteItem = (idToDelete: number) => {
  ingredients.value = ingredients.value.filter(item => item.id !== idToDelete);
  pendingDeletes.value.add(idToDelete);
};

const handleAddNewIngredient = async (newIngredient: IngredientGetPut) => {
  console.log('New ingredient data received from child:', newIngredient);

  // Set loading state to true before the API call
  isAddingIngredient.value = true;

  try {
     const response = await createIngredient(newIngredient);
     toast.success(`Ingredient ${response.id} ingredient successfully added!`);
  } catch (error) {
    console.error("Failed to add ingredient:", error);
    // Optionally show an error message to the user
  } finally {
    // Set loading state to false after the API call completes (or fails)
    isAddingIngredient.value = false;
    fetchIngredients();
  }
};

const handlePageSizeUpdate = (newSize: number) => {
  console.log('Page size changed to:', newSize);
  pageSize.value = newSize;
  fetchIngredients();
};

const handlePageChange = (direction: number) => {
  console.log('Page change requested:', direction);
  page.value += direction;
  if (page.value < 1) page.value = 1; // Ensure page doesn't go below 1
  if (page.value > totalPages.value) page.value = totalPages.value; // Ensure page doesn't exceed total pages
  fetchIngredients();
};

</script>

<style scoped>
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.buttons {
  display: flex;
  gap: 0.5rem;
}

</style>