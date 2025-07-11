<template>
  <div class="table-container">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th class="col-name">Name</th>
            <th class="col-numeric">D. Amount</th>
            <th class="col-text">Unit</th>
            <th class="col-text">Shop-style</th>
            <th class="col-numeric">Kcal</th>
            <th class="col-numeric">Prot.</th>
            <th class="col-numeric">Fats</th>
            <th class="col-numeric">Carb.</th>
            <th class="col-actions">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="!items || items.length === 0">
            <td colspan="9" class="empty-state">No items to display.</td>
          </tr>
          <tr v-for="item in items" :key="item.id">
            <td>
              <div class="name-cell-editable">
                <input
                  v-model="item.name"
                  type="text"
                  class="edit-input"
                  @change="handleCellEdition(item)"
                />
                <div v-if="item.labels && item.labels.length" class="tags-container">
                  <span
                    v-for="label in item.labels"
                    :key="label.label"
                    class="tag"
                    :style="{ backgroundColor: label.color }"
                    :class="label.label"
                  >
                    {{ label.label }}
                  </span>
                </div>
              </div>
            </td>

            <td>
              <input v-model.number="item.default_amount" type="number" class="edit-input-numeric" @change="handleCellEdition(item)" />
            </td>
            <td>
              <select v-model="item.unit" class="edit-select" @change="handleCellEdition(item)">
                <option v-for="option in unitOptions" :key="option" :value="option">{{ option }}</option>
              </select>
            </td>
            <td>
              <select v-model="item.shopStyle" class="edit-select" @change="handleCellEdition(item)">
                <option v-for="option in shopStyleOptions" :key="option" :value="option">{{ option }}</option>
              </select>
            </td>
            <td>
              <input v-model.number="item.kcal" type="number" class="edit-input-numeric" @change="handleCellEdition(item)" />
            </td>
            <td>
              <input v-model.number="item.protein" type="number" class="edit-input-numeric" @change="handleCellEdition(item)" />
            </td>
            <td>
              <input v-model.number="item.fat" type="number" class="edit-input-numeric" @change="handleCellEdition(item)" />
            </td>
            <td>
              <input v-model.number="item.carbs" type="number" class="edit-input-numeric" @change="handleCellEdition(item)" />
            </td>
            <td>
              <button class="action-button" @click="emit('deleteItem', item.id)" aria-label="Delete item">
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
        <span>Showing </span>
        <input
            v-model.number="pageSize"
            type="number"
            min="1"
            class="page-size-input"
            aria-label="Number of elements per page"
            @change="handlePageSizeEdition"
        />
        <span> out of {{ total }} elements</span>
    </div>
      <div class="pagination-controls">
        <button class="pagination-arrow" aria-label="Previous page" @click="emit('pageChanged', -1)"><</button>
        <span class="pagination-status">{{ currentPage }} / {{ totalPages }}</span>
        <button class="pagination-arrow" aria-label="Next page" @click="emit('pageChanged', 1)">></button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { IngredientGetPut, Unit, ShopStyle } from '@/types/types';
import { ref, watch, PropType } from 'vue';

// Enum values used in selects
const unitOptions = Object.values(Unit)
const shopStyleOptions = Object.values(ShopStyle)
// Props passed from parent component
const props = defineProps({
  ingredients: { type: Array as PropType<IngredientGetPut[]>, required: true },
  pageSize: { type: Number, required: true },
  currentPage: { type: Number, default: 1 },
  totalPages: { type: Number, default: 1 },
  page: { type: Number, default: 1 },
  total: { type: Number, default: 0 }
});

// Definition of emits (events that this component can emit to its parent)
const emit = defineEmits(['deleteItem', 'itemUpdated', 'pageChanged', 'pageSizeChanged']);
// ====== S T A T E ======
// Local copy of ingredients (this way we can edit them without affecting the original array until changes are confirmed)
const items = ref<IngredientGetPut[]>([]);
// Page size, initialized with the prop value
const pageSize = ref(props.pageSize);
// ====== W A T C H E R S ======
// Watch for changes in the ingredients prop and update local items
watch(() => props.ingredients, (newVal) => {
  items.value = JSON.parse(JSON.stringify(newVal));
}, { immediate: true, deep: true });
// Watch for changes in the pageSize prop and update local pageSize
watch(() => props.pageSize, (newVal) => {
    pageSize.value = newVal;
});

// ======= H A N D L E R S =======
// Handle edits commited in the table cells, emitting the updated item to the parent
const handleCellEdition = (updatedItem: IngredientGetPut) => {
  emit('itemUpdated', updatedItem);
};
// Handle page size edition, emitting the new size to the parent
const handlePageSizeEdition = () => {
  const newSize = Number(pageSize.value);
  if (newSize > 0 && newSize !== props.pageSize) {
    emit('pageSizeChanged', newSize);
  } else {
    pageSize.value = props.pageSize;
  }
};
// ======= E X P O S E D    M E T H O D S =======
// Method to get all current data if needed by parent
const getUpdatedItems = () => items.value;
// Expose these methods to the parent component
defineExpose({ getUpdatedItems });
</script>

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
  height: 765px;
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
.pagination-controls { display: flex; align-items: center; gap: 1rem; }
.pagination-arrow { background: none; border: none; cursor: pointer; font-size: 1.2rem; color: #555; }
.pagination-arrow:hover { color: #000; }

/* Styl kontenera zapewniający prawidłowe wyrównanie w pionie */
.footer-info {
  display: flex;
  align-items: center;
}

/* Główny styl dla pola input, aby wyglądało jak tekst */
.page-size-input {
  /* --- Reset wyglądu --- */
  background-color: transparent;
  border: none;
  border-bottom: 1px solid transparent; /* Niewidoczna dolna ramka dla płynnego przejścia w hover */
  border-top: 1px solid transparent; /* Niewidoczna dolna ramka dla płynnego przejścia w hover */
  outline: none;
  
  /* --- Dopasowanie czcionki i tekstu --- */
  font-family: inherit;
  font-size: inherit;
  color: inherit;
  font-weight: 400; /* Delikatne pogrubienie, aby liczba się wyróżniała */
  text-align: center;

  /* --- Rozmiar i odstępy --- */
  width: 25px; /* Szerokość dopasowana do ok. 3 cyfr */
  padding: 0px 0px;
  margin: 0px 1px; /* Niewielki margines po bokach */
  border-radius: 0px;

  /* --- Płynne przejścia dla efektów wizualnych --- */
  transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s;
}

/* Ukrycie strzałek w polach numerycznych (Chrome, Safari, Edge) */
.page-size-input::-webkit-outer-spin-button,
.page-size-input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
/* Ukrycie strzałek w polach numerycznych (Firefox) */
.page-size-input[type=number] {
  -moz-appearance: textfield;
}
/* --- Style interakcji --- */

/* Subtelna wskazówka przy najechaniu myszką */
.page-size-input:hover {
  border-bottom-color: #ccc;
}

/* Wyraźne zaznaczenie pola podczas edycji (focus) */
.page-size-input:focus {
  background-color: #ffffff;
}
</style>