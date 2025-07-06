<template>
  <div class="add-item-container">
    <div class="form-row">
      <!-- Name -->
      <div class="form-field col-name">
        <input type="text" v-model="newItem.name" placeholder="Item Name" />
      </div>
      <!-- D. Amount -->
      <div class="form-field col-numeric">
        <input type="number" v-model.number="newItem.defaultAmount" />
      </div>
      <!-- Unit -->
      <div class="form-field col-text">
        <input type="text" v-model="newItem.unit" />
      </div>
      <!-- Shop-style -->
      <div class="form-field col-text">
        <input type="text" v-model="newItem.shopStyle" />
      </div>
      <!-- Kcal -->
      <div class="form-field col-numeric">
        <input type="number" v-model.number="newItem.kcal" />
      </div>
      <!-- Prot. -->
      <div class="form-field col-numeric">
        <input type="number" v-model.number="newItem.protein" />
      </div>
      <!-- Fats -->
      <div class="form-field col-numeric">
        <input type="number" v-model.number="newItem.fats" />
      </div>
      <!-- Carb. -->
      <div class="form-field col-numeric">
        <input type="number" v-model.number="newItem.carbs" />
      </div>
      <!-- Actions -->
      <div class="form-field col-actions">
        <button class="add-button" @click="handleAddItem">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
          </svg>
          <span>Add</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

// --- TYPE DEFINITION ---
interface NewFoodItem {
  name: string;
  defaultAmount: number | null;
  unit: string;
  shopStyle: string;
  kcal: number | null;
  protein: number | null;
  fats: number | null;
  carbs: number | null;
}

// --- EMITS DEFINITION ---
const emit = defineEmits(['addItem']);

// --- FORM STATE ---
const getInitialState = (): NewFoodItem => ({
  name: '',
  defaultAmount: 100,
  unit: 'g',
  shopStyle: '',
  kcal: null,
  protein: null,
  fats: null,
  carbs: null,
});

const newItem = ref<NewFoodItem>(getInitialState());

// --- METHODS ---
const handleAddItem = () => {
  if (!newItem.value.name.trim()) {
    alert('Please enter an item name.');
    return;
  }
  emit('addItem', { ...newItem.value });
  newItem.value = getInitialState();
};
</script>

<style scoped>
.add-item-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  padding: 10px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  background-color: #fdfdfd;
  margin-top: 1rem;
}

/* Using flexbox to create a row of fields that mimics the table layout */
.form-row {
  display: flex;
  flex-wrap: nowrap;
  gap: 10px; /* Corresponds to padding in table cells */
  align-items: center;
  min-width: 950px; /* Match table min-width */
}

.form-field {
  flex-shrink: 1;
}

/* Column width definitions - mirroring the table's styles */
.col-name { width: 30%; }
.col-numeric { width: 8%; }
.col-text { width: 10%; }
.col-actions { width: 10%; flex-shrink: 0; }

input[type="text"],
input[type="number"] {
  width: 100%;
  padding: 8px 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 0.9rem;
  box-sizing: border-box;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

input:focus {
  outline: none;
  border-color: #28a745;
  box-shadow: 0 0 0 2px rgba(40, 167, 69, 0.2);
}

.add-button {
  background-color: #28a745;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 8px 16px;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  width: 100%;
  transition: background-color 0.2s ease;
}

.add-button:hover {
  background-color: #218838;
}

.add-button svg {
  stroke: white;
  stroke-width: 0.5;
}
</style>