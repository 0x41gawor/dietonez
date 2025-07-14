<template>
  <div class="table-container">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th class="col-name">Name</th>
            <th class="col-numeric">Amount</th>
            <th class="col-numeric">Kcal</th>
            <th class="col-numeric">Prot.</th>
            <th class="col-numeric">Fats</th>
            <th class="col-numeric">Carb.</th>
            <th class="col-actions">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="!items || items.length === 0">
            <td colspan="7" class="empty-state">No items to display.</td>
          </tr>
          <tr v-for="item in items" :key="item.ingredient.id">
            <!-- NAME as SELECT -->
            <td>
              <select
                v-model="item.ingredient.id"
                class="edit-select"
                @change="handleIngredientChange(item)"
              >
                <option disabled value="">Select ingredient</option>
                <option
                  v-for="option in getAvailableOptions(item)"
                  :key="option.id"
                  :value="option.id"
                >
                  {{ option.name }}
                </option>
              </select>
            </td>

            <!-- AMOUNT editable -->
            <td>
              <div class="amount-wrapper">
                <input
                  v-model.number="item.amount"
                  type="number"
                  class="edit-input-numeric"
                  @change="handleIngredientChange(item)"
                />
                <span class="unit-label">[{{ item.ingredient.unit || 'g' }}]</span>
              </div>
            </td>

            <!-- Read-only columns -->
            <td>{{ item.ingredient.kcal }}</td>
            <td>{{ item.ingredient.protein }}</td>
            <td>{{ item.ingredient.fat }}</td>
            <td>{{ item.ingredient.carbs }}</td>

            <!-- Actions -->
            <td>
              <button class="action-button" @click="emit('deleteItem', item.ingredient.id)" aria-label="Delete item">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/>
                  <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3V2h11v1h-11z"/>
                </svg>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="table-footer">
      <div class="footer-info">
        <span class="macro-badge kcal">{{ total.kcal }}</span>
        <span class="macro-badge protein">{{ total.protein }}</span>
        <span class="macro-badge fat">{{ total.fat }}</span>
        <span class="macro-badge carbs">{{ total.carbs }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { IngredientInDishGet } from '@/types/types';
import { ref, onMounted, computed } from 'vue';
import { GetIngredientsParams, getIngredientById, getIngredients } from '@/api/ingredients';
import { calculateIngredientSummary } from '@/api/dishes';

const props = defineProps<{
  items: IngredientInDishGet[];
}>();

const total = computed(() => {
  const sum = props.items.reduce(
    (acc, item) => {
      acc.kcal += item.ingredient.kcal || 0;
      acc.protein += item.ingredient.protein || 0;
      acc.fat += item.ingredient.fat || 0;
      acc.carbs += item.ingredient.carbs || 0;
      return acc;
    },
    { kcal: 0, protein: 0, fat: 0, carbs: 0 }
  );

  const round1 = (v: number) => Math.round(v * 10) / 10;
  return {
    kcal: round1(sum.kcal),
    protein: round1(sum.protein),
    fat: round1(sum.fat),
    carbs: round1(sum.carbs),
  };
});

const emit = defineEmits<{
  (e: 'updateItem', item: any): void;
  (e: 'deleteItem', id: number): void;
}>();

onMounted(() => {
  fetchIngredientOptions();
});

const ingredientOptions = ref<{ id: number; name: string }[]>([]);

const fetchIngredientOptions = async () => {
  const params: GetIngredientsParams = {
    page: 1,
    pageSize: 100,
    short: true,
  };

  try {
    const response = await getIngredients(params);
    ingredientOptions.value = response.ingredients.map(ingredient => ({
      id: ingredient.id,
      name: ingredient.name,
    }));
  } catch (error) {
    console.error('Failed to fetch ingredients:', error);
  }
};

const getAvailableOptions = (currentItem: IngredientInDishGet) => {
  const usedIds = props.items
    .filter(item => item !== currentItem)
    .map(item => item.ingredient.id);

  return ingredientOptions.value
    .filter(option => !usedIds.includes(option.id))
    .sort((a, b) => a.name.localeCompare(b.name));
};

const handleIngredientChange = async (item: IngredientInDishGet) => {
  try {
    const fullIngredient = await getIngredientById(item.ingredient.id);

    item.ingredient.name = fullIngredient.name;
    item.ingredient.unit = fullIngredient.unit;
    item.ingredient.shopStyle = fullIngredient.shopStyle;
    item.ingredient.default_amount = fullIngredient.default_amount;
    item.ingredient.labels = fullIngredient.labels;

    const summary = await calculateIngredientSummary({
      ingredient: { id: item.ingredient.id, name: item.ingredient.name },
      amount: item.amount,
    });

    item.ingredient.kcal = summary.kcal;
    item.ingredient.protein = summary.proteins;
    item.ingredient.fat = summary.fats;
    item.ingredient.carbs = summary.carbs;

    emit('updateItem', item);
  } catch (error) {
    console.error(`Failed to update ingredient with ID ${item.ingredient.id}:`, error);
  }
};
</script>

<style scoped>
/* ... bez zmian — cały dotychczasowy CSS z Twojego kodu ... */
</style>


<style scoped>
.name-cell-editable {
  display: flex;
  align-items: center;
  gap: 8px;
}
.name-cell-editable .edit-input {
  flex-grow: 1;
  min-width: 100px;
  border-radius: 0;
}
.tags-container {
  color: white;
  display: flex;
  gap: 4px;
  flex-shrink: 0;
  white-space: nowrap;
}
.edit-input, .edit-select, .edit-input-numeric {
  width: 100%;
  padding: 0;
  margin: 0;
  border-radius: 0;
  box-sizing: border-box;
  background-color: transparent;
  border: none;
  outline: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  font-family: inherit;
  font-size: inherit;
  color: inherit;
  cursor: text;
}
.edit-input-numeric {
  text-align: left;
}
.edit-select {
  cursor: pointer;
}
.edit-input-numeric::-webkit-outer-spin-button,
.edit-input-numeric::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
.edit-input:focus, .edit-select:focus, .edit-input-numeric:focus {
  background-color: #ffffff;
  outline: 2px solid #818cf8;
  outline-offset: -1px;
  border-radius: 0px;
}
.table-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  background-color: #ffffff;
  display: flex;
  flex-direction: column;
  height: 400px;
}
.table-wrapper { flex: 1; overflow: auto; }
table { width: 100%; border-collapse: collapse; min-width: 950px; }
th {
  padding: 8px 10px;
  text-align: left;
  font-weight: 100;
  color: #666;
  font-size: 0.875rem;
  border-bottom: px solid #e0e0e0;
  white-space: nowrap;
  background-color: #f9f9f9;
  position: sticky;
  top: 0;
  z-index: 1;
}
.col-name { width: 50%; }
.col-numeric { width: 4%; }
.col-text { width: 5%; }
.col-actions { width: 5%; text-align: center; }
tbody tr:hover { background-color: #f5f5f5; }
td {
  padding: 2px 10px;
  border-bottom: 1px solid #e0e0e0;
  color: #333;
  font-size: 0.75rem;
  vertical-align: middle;
}
.tag { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 0.6rem; font-weight: 500; }
.action-button { background-color: var(--grey-100); border: none; color: var(--btn-delete); padding: 6px 9px; border-radius: 1px; cursor: pointer; display: inline-flex; transition: background-color 0.2s ease; }
.action-button:hover { color: var(--btn-delete-hover); background-color: var(--grey-200); }
td:last-child { text-align: center; }
.table-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 16px;
  border-top: 1px solid #e0e0e0;
  font-size: 0.8rem;
  color: #666;
  flex-shrink: 0;
  height: 20px;
}

/* Styl kontenera zapewniający prawidłowe wyrównanie w pionie */
.footer-info {
  display: flex;
  justify-content: flex-start;
  padding-left: calc(50% + 5.1*4% + 4px); /* 50% na .col-name, 4% na .col-numeric dla Amount */
  gap: 4%;
}

.amount-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 4px;
  max-width: 100px; /* lub więcej jeśli potrzeba */
  white-space: nowrap;
}

.unit-label {
  font-size: 0.7rem;
  color: #777;
  flex-shrink: 0;
  white-space: nowrap;
}
.macro-badge {
  display: inline-block;
  min-width: 24px;
  padding: 4px 13px;
  text-align: center;
  border-radius: 12%;
  border: 2px solid;
  font-size: 0.8rem;
  color: #000;
}

.macro-badge.kcal {
  border-color: #f9a825; /* żółty */
  font-weight: bold;
}
.macro-badge.protein {
  border-color: #2196f3; /* niebieski */
}
.macro-badge.fat {
  border-color: #ef5350; /* czerwony */
}
.macro-badge.carbs {
  border-color: #757575; /* szary */
}
</style>