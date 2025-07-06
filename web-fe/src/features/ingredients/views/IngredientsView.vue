<template>
  <section>
    <!-- The header remains the same -->
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

    <!-- 1. The IngredientTable component now receives the filtered data as a prop -->
    <!-- It also listens for the 'deleteItem' event to call our handler function -->
    <IngredientTable 
      :food-items="filteredIngredients"
      :current-page="1"
      :total-pages="1"
      @delete-item="handleDeleteItem"
    />

    <!-- 2. The form component for adding new ingredients -->
    <!-- It listens for the 'addItem' event -->
    <AddIngredientForm 
      @add-item="handleAddItem"
    />

  </section>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
// 3. Update imports to point to the correct component files
import IngredientTable from '../components/IngredientTable2.vue'; 
import AddIngredientForm from '../components/AddItemRow.vue';
import SearchBar from '@/components/SearchBar.vue'

// --- TYPE DEFINITIONS (These can be moved to a separate types.ts file) ---
interface Tag {
  text: string;
  className: string;
}

interface FoodItem {
  id: number;
  name: string;
  brand?: string;
  tags?: Tag[];
  defaultAmount: number;
  unit: string;
  shopStyle: string;
  kcal: number;
  protein: number;
  fats: number;
  carbs: number;
}

// 4. State Management: The parent component now holds the data
const searchText = ref('');

// This ref holds the master list of all ingredients
const allIngredients = ref<FoodItem[]>([
  { id: 1, name: "Rolada ustrzycka", brand: "Regionalne Szlaki", tags: [{ text: "probiotyk", className: "tag-probiotic" }, { text: "witamina C", className: "tag-vitamin" }, { text: "błonnik", className: "tag-fiber" }], defaultAmount: 100, unit: "g", shopStyle: "Zapasy", kcal: 326, protein: 28, fats: 28, carbs: 12 },
  { id: 2, name: "Filet z piersi kurczaka", brand: "Kraina Mięs", defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9 },
  { id: 2, name: "Filet z piersi kurczaka", brand: "Kraina Mięs", defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9 },
  { id: 2, name: "Filet z piersi kurczaka", brand: "Kraina Mięs", defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9 },
  { id: 2, name: "Filet z piersi kurczaka", brand: "Kraina Mięs", defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9 },
  { id: 2, name: "Filet z piersi kurczaka", brand: "Kraina Mięs", defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9 },
  { id: 2, name: "Filet z piersi kurczaka", brand: "Kraina Mięs", defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9 },
  { id: 2, name: "Filet z piersi kurczaka", brand: "Kraina Mięs", defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9 },
  { id: 2, name: "Filet z piersi kurczaka", brand: "Kraina Mięs", defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9 },
  { id: 2, name: "Filet z piersi kurczaka", brand: "Kraina Mięs", defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9 },
  { id: 3, name: "Kefir", brand: "Robico", defaultAmount: 100, unit: "Łyżka", shopStyle: "G.S.", kcal: 123, protein: 8.9, fats: 1, carbs: 45 },
  { id: 4, name: "Serek wiejski wysokobiałkowy", brand: "OSM Siedlce", defaultAmount: 100, unit: "g", shopStyle: "Lidl", kcal: 34, protein: 12, fats: 3.2, carbs: 12 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
  { id: 5, name: "Burger Wołowy", brand: "Rzeźnik", defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56 },
]);

// 5. Computed property to filter the list based on the search text
const filteredIngredients = computed(() => {
  if (!searchText.value) {
    return allIngredients.value;
  }
  return allIngredients.value.filter(item => 
    item.name.toLowerCase().includes(searchText.value.toLowerCase())
  );
});

// 6. Event Handlers to modify the state
const handleAddItem = (newItem: Omit<FoodItem, 'id'>) => {
  const newEntry: FoodItem = {
    id: Date.now(), // Use a simple timestamp for a unique ID in this mock
    ...newItem,
    // Provide default values for any potentially null numbers from the form
    defaultAmount: newItem.defaultAmount ?? 0,
    kcal: newItem.kcal ?? 0,
    protein: newItem.protein ?? 0,
    fats: newItem.fats ?? 0,
    carbs: newItem.carbs ?? 0,
  };
  allIngredients.value.push(newEntry);
};

const handleDeleteItem = (idToDelete: number) => {
  allIngredients.value = allIngredients.value.filter(item => item.id !== idToDelete);
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
  background-color: #6c757d;
  color: white;
}

.btn-primary {
  /* background-color: var(--btn-add); */
  background-color: #007bff;
  color: white;
}
</style>