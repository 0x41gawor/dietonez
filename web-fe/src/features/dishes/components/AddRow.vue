<template>
  <div class="add-row">
    <!-- Name Column (SELECT) -->
    <div class="add-cell col-name">
     <div class="add-cell col-name">
  <input
    ref="nameInput"
    v-model="searchQuery"
    class="form-input"
    list="ingredient-options"
    placeholder="Type or select ingredient..."
    @input="handleSearchInput"
    aria-label="Select Ingredient"
  />
  <datalist id="ingredient-options">
    <option v-for="opt in filteredIngredientOptions" :key="opt.id" :value="opt.name" />
  </datalist>
</div>
 
    </div>

    <!-- Amount Column -->
    <div class="add-cell col-numeric">
      <input
        v-model.number="amount"
        type="number"
        class="form-input form-input-numeric"
        placeholder="100"
        aria-label="Default Amount"
      />
    </div>

    <!-- Unit -->
    <div class="add-cell col-text">
      <span class="readonly-cell">{{ newIngredient.unit || '-' }}</span>
    </div>

    <!-- Kcal -->
    <div class="add-cell col-numeric">
      <span class="readonly-cell">{{ newIngredient.kcal ?? 0 }}</span>
    </div>

    <!-- Protein -->
    <div class="add-cell col-numeric">
      <span class="readonly-cell">{{ newIngredient.protein ?? 0 }}</span>
    </div>

    <!-- Fat -->
    <div class="add-cell col-numeric">
      <span class="readonly-cell">{{ newIngredient.fat ?? 0 }}</span>
    </div>

    <!-- Carbs -->
    <div class="add-cell col-numeric">
      <span class="readonly-cell">{{ newIngredient.carbs ?? 0 }}</span>
    </div>

    <!-- Actions -->
    <div class="add-cell col-actions">
      <AddButton @click="handleAdd" :disabled="isAddDisabled" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick } from 'vue';
import AddButton from '@/components/AddButton.vue';
import { getIngredientById,  GetIngredientsParams, getIngredients, searchIngredients } from '@/api/ingredients';
import { IngredientMin, IngredientInDishPut, IngredientGetPut, Unit, ShopStyle, IngredientInDishGet } from '@/types/types';

const searchQuery = ref('')

const handleSearchInput = async () => {
  if (!searchQuery.value || searchQuery.value.trim() === '') {
    ingredientOptions.value = []
    return
  }
  try {
    const response = await searchIngredients({ query: searchQuery.value, reslen: 20 })
    ingredientOptions.value = response.ingredients
  } catch (err) {
    console.error('Failed to search ingredients', err)
  }
}

const emit = defineEmits<{
  (e: 'add-ingredient', payload: IngredientInDishPut): void;
}>();

const ingredientOptions = ref<IngredientMin[]>([]);

const props = defineProps<{
  usedIngredients: IngredientInDishGet[];
}>();

const nameInput = ref<HTMLInputElement | null>(null);

const filteredIngredientOptions = computed(() => {
  const usedIds = new Set(props.usedIngredients.map(i => i.ingredient.id));

  return ingredientOptions.value
    .filter(opt => !usedIds.has(opt.id))
    .sort((a, b) => a.name.localeCompare(b.name, undefined, { sensitivity: 'base' }));
});



const fetchIngredientOptions = async () => {
  try {
    const params: GetIngredientsParams = { page: 1, pageSize: 300, short: true };
    const response = await getIngredients(params);
    ingredientOptions.value = response.ingredients;
  } catch (error) {
    console.error('Failed to load ingredient options:', error);
  }
};

onMounted(() => {
  fetchIngredientOptions();
});

const getInitialState = (): IngredientGetPut => ({
  id: 0,
  name: '',
  unit: Unit.Gram,
  shopStyle: ShopStyle.Fresh,
  default_amount: 0,
  kcal: 0,
  protein: 0,
  fat: 0,
  carbs: 0, 
  labels: [],
});

const newIngredient = ref(getInitialState());
const amount = ref(0);

watch(amount, async (newAmount) => {
  if (
    newIngredient.value.id === 0 ||
    newAmount == null ||          // null lub undefined
    newAmount <= 0 ||             // 0 lub wartości ujemne
    isNaN(newAmount)              // NaN
  ) {
    return;
  }

  try {
    const summary = await calculateIngredientSummary({
      ingredient: { id: newIngredient.value.id, name: newIngredient.value.name },
      amount: newAmount,
    });

    newIngredient.value.kcal = summary.kcal;
    newIngredient.value.protein = summary.proteins;
    newIngredient.value.fat = summary.fats;
    newIngredient.value.carbs = summary.carbs;
  } catch (error) {
    console.error('Failed to update summary after amount change:', error);
  }
});

const isAddDisabled = computed(() => {
  return newIngredient.value.id === 0;
});

import { calculateIngredientSummary } from '@/api/dishes'; // lub inna ścieżka

const handleSelection = () => {
  const chosen = ingredientOptions.value.find(opt => opt.name === searchQuery.value)
  if (!chosen) {
    console.warn('Ingredient not found:', searchQuery.value)
    return
  }

  emit('add-ingredient', {
    ingredient: {
      id: chosen.id,
      name: chosen.name,
    },
    amount: amount.value,
  })

  // reset
  searchQuery.value = ''
  amount.value = 0
  newIngredient.value = getInitialState()

  nextTick(() => {
    nameInput.value?.focus()
  })
}


const handleIngredientSelection = async () => {
  const id = newIngredient.value.id;
  if (!id) return;

  try {
    const full = await getIngredientById(id);

    newIngredient.value.name = full.name;
    newIngredient.value.unit = full.unit;
    newIngredient.value.shopStyle = full.shopStyle;
    newIngredient.value.default_amount = full.default_amount;
    newIngredient.value.labels = full.labels;
    amount.value = full.default_amount || 0;

    // Używamy wartości ID + amount do wyliczenia makro
    const summary = await calculateIngredientSummary({
      ingredient: { id: full.id, name: full.name },
      amount: amount.value,
    });

    newIngredient.value.kcal = summary.kcal;
    newIngredient.value.protein = summary.proteins;
    newIngredient.value.fat = summary.fats;
    newIngredient.value.carbs = summary.carbs;
  } catch (err) {
    console.error(`Failed to process ingredient ID ${id}:`, err);
  }
};


const handleAdd = () => {
  emit('add-ingredient', {
    ingredient: {
      id: newIngredient.value.id,
      name: newIngredient.value.name,
    },
    amount: amount.value,
  });

  newIngredient.value = getInitialState();

  nextTick(() => {
    nameInput.value?.focus();
  });
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
  flex: 1 1 40%;
}
.col-numeric {
  flex: 0 0 50px;
}
.col-text {
  flex: 0 0 55px;
}
.col-actions {
  flex: 0 0 50px;
  justify-content: center;
}

.col-name .form-input {
  border-top-left-radius: 6px;
  border-bottom-left-radius: 6px;
}

/* Readonly display in cells */
.readonly-cell {
  font-size: 0.75rem;
  color: #333;
  width: 100%;
  text-align: center;
  background-color: #fff;
  border: 1px solid #e0e0e0;
  padding: 0 4px;
  line-height: 28px;
}

.form-select {
  width: 100%;
  padding: 8px 4px;
  font-size: 0.75rem;
  border-radius: 2px;
  background-color: #ffffff;
  border: 1px solid #ccc;
  box-sizing: border-box;
}
</style>
