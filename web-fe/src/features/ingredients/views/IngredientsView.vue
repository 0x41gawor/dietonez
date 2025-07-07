<template>
  <section>
    <div class="header">
      <SearchBar
        v-model="searchText"
        placeholder="Search ingredients..."
      />
      <div class="buttons">
        <button class="btn btn-secondary">Revert</button>
        <button class="btn btn-primary">Update</button>
      </div>
    </div>

    <IngredientTable 
      :food-items="ingredients"
      :current-page="1"
      :total-pages="1"
      @delete-item="handleDeleteItem"
      @item-updated="handleItemUpdate"
    />

    <!-- <AddIngredientForm 
      @add-item="handleAddItem"
    /> -->

  </section>
</template>

<script setup lang="ts">
import { onMounted, ref, watch } from 'vue'
// 3. Update imports to point to the correct component files
import IngredientTable from '../components/IngredientTable.vue'; 
import AddIngredientForm from '../components/AddItemRow.vue';
import SearchBar from '@/components/SearchBar.vue'
import { IngredientGetPut } from '@/types/types';
import { getIngredients } from '@/api/ingredients'

const ingredients = ref<IngredientGetPut[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = ref(30)

async function fetchIngredients() {
  const result = await getIngredients({ page: page.value, pageSize: pageSize.value })
  ingredients.value = result.ingredients
  total.value = result.total
}

// fetch on load
onMounted(fetchIngredients)

// (optional) react to page change
watch([page, pageSize], fetchIngredients)

// 4. State Management: The parent component now holds the data
const searchText = ref('');

// const handleAddItem = (newItem: Omit<IngredientGetPut, 'id'>) => {
//   const newEntry: FoodItem = {
//     id: Date.now(), // Use a simple timestamp for a unique ID in this mock
//     ...newItem,
//     // Provide default values for any potentially null numbers from the form
//     defaultAmount: newItem.defaultAmount ?? 0,
//     kcal: newItem.kcal ?? 0,
//     protein: newItem.protein ?? 0,
//     fats: newItem.fats ?? 0,
//     carbs: newItem.carbs ?? 0,
//   };
//   allIngredients.value.push(newEntry);
// };

// NEW: Handler for the real-time update event from the child table
const handleItemUpdate = (updatedItem: IngredientGetPut) => {
  console.log('An item was updated in real-time:', updatedItem);

  // Find the index of the item in the master list
  const index = ingredients.value.findIndex(item => item.id === updatedItem.id);
  
  // If found, update the item in the master list
  if (index !== -1) {
    // IMPORTANT: Replace the entire object to ensure reactivity.
    ingredients.value[index] = updatedItem;
    
    // At this point, you could also trigger an auto-save to your backend API.
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