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
      :page="page"
      :total="total"
      @delete-item="handleDeleteItem"
      @item-updated="handleItemUpdate"
    />

    <!-- <AddIngredientForm 
      @add-item="handleAddItem"
    /> -->

  </section>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useToast } from "vue-toastification";
import { onMounted, ref, watch } from 'vue'
import IngredientTable from '../components/IngredientTable.vue'; 
import SearchBar from '@/components/SearchBar.vue';
import RevertButton from '@/components/RevertButton.vue';
import UpdateButton from '@/components/UpdateButton.vue';
import { IngredientGetPut } from '@/types/types';
import { getIngredients, updateIngredients } from '@/api/ingredients'

const ingredients = ref<IngredientGetPut[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = ref(100)
const totalPages = ref(1)
const toast = useToast();
const pendingChanges = ref<Record<number, IngredientGetPut>>({});

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
  return Object.keys(pendingChanges.value).length > 0;
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
  
  // Inform the user
  toast.info("Reverted all pending changes.");
  fetchIngredients();
};

// When the "Update" button is clicked
const handleUpdateBUttonClick = async () => {
  // Get an array of the ingredient objects that have changed
  const changesToSubmit = Object.values(pendingChanges.value);

  if (changesToSubmit.length === 0) {
    toast.warning("No changes to update.");
    return;
  }

  console.log('Update button clicked, saving changes...', changesToSubmit);
  
  try {
    // Call the API with the pending changes
    const response = await updateIngredients(changesToSubmit);

    // IMPORTANT: Clear the pending changes state after a successful update
    pendingChanges.value = {};

    // Show a success toast with the response from the backend
    toast.success(`${response.updated} ingredient(s) successfully updated!`);
    
    // Optional: You might want to re-fetch to ensure data consistency
    fetchIngredients();

  } catch (error) {
    // If the API call fails, show an error toast.
    // We DON'T clear pendingChanges, so the user can try again.
    console.error("Failed to update ingredients:", error);
    toast.error("Failed to update ingredients. Please try again.");
  }
};
const handleDeleteItem = (idToDelete: number) => {
  ingredients.value = ingredients.value.filter(item => item.id !== idToDelete);
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
  gap: 1rem;
}

.btn {
  padding: 0.5rem 1.2rem;
  /* Assuming you have these CSS variables defined globally */
  /* border-radius: var(--radius); */ 
  border-radius: 6px;
  font-weight: 500;
  cursor: pointer;
  border: none;
}

.btn-secondary {
  /* background-color: var(--btn-update); */
  background-color: var(--btn-revert);
  color: white;
}

.btn-primary {
  /* background-color: var(--btn-add); */
  background-color: var(--btn-update);
  color: white;
}
</style>