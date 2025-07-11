<template>
  <div class="add-row">
    <!-- Name Column -->
    <div class="add-cell col-name">
      <input
        v-model="newIngredient.name"
        type="text"
        class="form-input"
        placeholder="Ingredient Name"
        aria-label="Ingredient Name"
      />
    </div>

    <!-- D. Amount Column -->
    <div class="add-cell col-numeric">
      <input
        v-model.number="newIngredient.default_amount"
        type="number"
        class="form-input form-input-numeric"
        placeholder="100"
        aria-label="Default Amount"
      />
    </div>

    <!-- Unit Column -->
    <div class="add-cell col-text">
      <select v-model="newIngredient.unit" class="form-select" aria-label="Unit">
        <!-- The default disabled option is removed to let the initial state take precedence -->
        <option v-for="option in unitOptions" :key="option" :value="option">{{ option }}</option>
      </select>
    </div>

    <!-- Shop-style Column -->
    <div class="add-cell col-text">
      <select v-model="newIngredient.shopStyle" class="form-select" aria-label="Shop-style">
        <option v-for="option in shopStyleOptions" :key="option" :value="option">{{ option }}</option>
      </select>
    </div>

    <!-- Kcal Column -->
    <div class="add-cell col-numeric">
      <input
        v-model.number="newIngredient.kcal"
        type="number"
        class="form-input form-input-numeric"
        placeholder="0"
        aria-label="Kcal"
      />
    </div>

    <!-- Prot. Column -->
    <div class="add-cell col-numeric">
      <input
        v-model.number="newIngredient.protein"
        type="number"
        class="form-input form-input-numeric"
        placeholder="0"
        aria-label="Protein"
      />
    </div>

    <!-- Fats Column -->
    <div class="add-cell col-numeric">
      <input
        v-model.number="newIngredient.fat"
        type="number"
        class="form-input form-input-numeric"
        placeholder="0"
        aria-label="Fats"
      />
    </div>

    <!-- Carb. Column -->
    <div class="add-cell col-numeric">
      <input
        v-model.number="newIngredient.carbs"
        type="number"
        class="form-input form-input-numeric"
        placeholder="0"
        aria-label="Carbs"
      />
    </div>

    <!-- Actions Column -->
    <div class="add-cell col-actions">
      <AddButton @click="handleAdd" :disabled="isAddDisabled" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, PropType } from 'vue';
import AddButton from '../../../components/AddButton.vue'
import { IngredientPost, Unit, ShopStyle } from '@/types/types';
const unitOptions = Object.values(Unit)
const shopStyleOptions = Object.values(ShopStyle)

const props = defineProps({
  loading: {
    type: Boolean,
    default: false
  }
});

// UPDATED: The emit definition now strictly uses the IngredientGetPut interface
const emit = defineEmits<{
  (e: 'add-ingredient', payload: IngredientPost): void;
}>();

// Function to create the initial (empty) state for the form
const getInitialState = (): IngredientPost => ({
  name: '',
  default_amount: 100,
  unit: Unit.Gram, // Use a default from options or a fallback
  shopStyle: ShopStyle.Lidl, // Use a default from options or a fallback
  kcal: null,
  protein: null,
  fat: null,
  carbs: null,
});

const newIngredient = ref<IngredientPost>(getInitialState());

const isAddDisabled = computed(() => {
  return !newIngredient.value.name.trim() || props.loading;
});

// UPDATED: This function now transforms the form state into a valid IngredientGetPut object
const handleAdd = () => {
  if (isAddDisabled.value) return;

  // Create the payload object conforming to the IngredientGetPut interface
  const payload: IngredientPost = {
    // 1. Set fixed values as requested
    labels: undefined, // `labels` is optional (`?`). `undefined` is the correct way to represent a missing optional value. `null` would cause a type error.

    // 2. Map values from the form state
    name: newIngredient.value.name.trim(),
    unit: newIngredient.value.unit,
    shopStyle: newIngredient.value.shopStyle,
    
    // 3. Handle nullable numbers: convert null (from empty inputs) to 0 or a default
    kcal: newIngredient.value.kcal ?? null,
    protein: newIngredient.value.protein ?? null,
    fat: newIngredient.value.fat ?? null,
    carbs: newIngredient.value.carbs ?? null,
    default_amount: newIngredient.value.default_amount ?? 100,
  };
  
  // Emit the fully-formed, type-safe payload
  emit('add-ingredient', payload);
  
  // Reset the form for the next entry
  newIngredient.value = getInitialState();
};
</script>

<style scoped>
/* Base styling for form inputs to match the figma mock */
.form-input,
.form-select {
  width: 100%;
  padding: 8px 4px;
  margin: 0;
  box-sizing: border-box;
  background-color: #ffffff;
  border-radius: 2px;
  outline: none;
  font-family: inherit;
  font-size: 0.75rem;
  color: #333;

  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.form-input::placeholder {
  color: #9ca3af;
}

.form-input-numeric {
  text-align: left;
}

/* Remove spinners from number inputs */
.form-input-numeric::-webkit-outer-spin-button,
.form-input-numeric::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
.form-input-numeric {
  appearance: textfield;
  -moz-appearance: textfield;
}

.form-select {
  cursor: pointer;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
  background-position: right 0.5rem center;
  background-repeat: no-repeat;
  background-size: 1.5em 1.5em;
  padding-right: 2.5rem;
}

.form-input:focus,
.form-select:focus {
  border-color: #818cf8;
  box-shadow: 0 0 0 2px rgba(129, 140, 248, 0.25);
}

/* Main container for the add row section */
.add-row {
  display: flex;
  align-items: stretch; /* Make cells equal height */
  gap: 1px;
  padding: 8px 1px;
  background-color: #f9f9f9; /* Match table header background */
}

/* Wrapper for each cell in the add row */
.add-cell {
  box-sizing: border-box;
  display: flex;
  align-items: center;
}

/* 
  Column layout styles.
  Using flex-basis and min-width to create a responsive but aligned layout
  that closely matches the parent table's column proportions.
*/
.col-name {
  flex: 1 1 45%;
}
.col-numeric {
  flex: 0 0 52px;
}
.col-text {
  flex: 0 0 90px;
}
.col-actions {
  flex: 0 0 55px;
  justify-content: center;
}

.col-name .form-input {
  border-top-left-radius: 6px;
  border-bottom-left-radius: 6px;
}
</style>