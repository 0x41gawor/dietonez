<template>
  <div class="table-container">
    <div class="table-wrapper">
      <table>
        <thead>
           <th class="col-name" :class="['header-cell', mealClass]">Name</th>
            <th class="col-numeric" :class="['header-cell', mealClass]">Kcal</th>
            <th class="col-numeric" :class="['header-cell', mealClass]">Prot.</th>
            <th class="col-numeric" :class="['header-cell', mealClass]">Fats</th>
            <th class="col-numeric" :class="['header-cell', mealClass]">Carb.</th>
      </thead>
        <tbody>
          <tr v-if="!items || items.length === 0">
            <td colspan="9" class="empty-state">No items to display.</td>
          </tr>
          <tr v-for="item in items" :key="item.id" @click="goToEdit(item.id)" class="clickable-row">
            <td >
              <div class="name-cell-editable">
                <input
                  v-model="item.name"
                  type="text"
                  @click.stop
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
            <!-- Tylko do odczytu -->
            <td>{{ item.kcal }}</td>
            <td>{{ item.protein }}</td>
            <td>{{ item.fat }}</td>
            <td>{{ item.carbs }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="table-footer">
    </div>
  </div>
</template>

<script setup lang="ts">
import { DishGetShort } from '@/types/types';
import { ref, watch, PropType, computed } from 'vue';
import { useRouter } from 'vue-router'
const router = useRouter()

// Props passed from parent component
const props = defineProps({
  items: { type: Array as PropType<DishGetShort[]>, required: true },
  currentPage: { type: Number, default: 1 },
  totalPages: { type: Number, default: 1 },
  pageSize: { type: Number, required: true },
  page: { type: Number, default: 1 },
  total: { type: Number, default: 0 },
  meal: { type: String as PropType<'Breakfast' | 'MainMeal' | 'Pre-Workout' | 'Supper'>, required: true }
});
  
const mealClass = computed(() => {

  console.log('meal', props.meal)
  const map: Record<string, string> = {
    'Breakfast': 'header-breakfast',
    'MainMeal': 'header-mainmeal',
    'Pre-Workout': 'header-preworkout',
    'Supper': 'header-supper'
  }
  return map[props.meal]
})

// Definition of emits (events that this component can emit to its parent)
const emit = defineEmits(['deleteItem', 'itemUpdated', 'pageChanged', 'pageSizeChanged']);
// ====== S T A T E ======
// Local copy of ingredients (this way we can edit them without affecting the original array until changes are confirmed)
const items = ref<DishGetShort[]>([]);
// Page size, initialized with the prop value
const pageSize = ref(props.pageSize);
// ====== W A T C H E R S ======
// Watch for changes in the ingredients prop and update local items
watch(() => props.items, (newVal) => {
  items.value = JSON.parse(JSON.stringify(newVal));
}, { immediate: true, deep: true });
// Watch for changes in the pageSize prop and update local pageSize
watch(() => props.pageSize, (newVal) => {
    pageSize.value = newVal;
});

const goToEdit = (id: number) => {
  router.push(`/dishes/${id}/edit`)
}

// ======= H A N D L E R S =======
// Handle edits commited in the table cells, emitting the updated item to the parent
const handleCellEdition = (updatedItem: DishGetShort) => {
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
// E
defineExpose({ getUpdatedItems });
</script>

<style scoped>
.name-cell-editable {
  display: flex;
  align-items: center;
  gap: 8px;
}
.name-cell-editable .edit-input {
  width: fit-content;
  max-width: 100%;
  min-width: 100px;
  flex-grow: 0;
  flex-shrink: 1;
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
  height: 760px;
}
.table-wrapper { flex: 1; overflow: auto; }
table { width: 100%; border-collapse: collapse; min-width: 950px; }
th {
  padding: 8px 10px;
  text-align: left;
  font-weight: 100;
  color: #fff;
  font-size: 0.875rem;
  border-bottom: px solid #e0e0e0;
  white-space: nowrap;
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
  padding: 12px 14px;
  border-bottom: 1px solid #e0e0e0;
  color: #333;
  font-size: 0.95rem;
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

.clickable-row {
  cursor: pointer;
}
.header-row {
  transition: background-color 0.3s ease;
  opacity: 0.6;
  text-color: #fff;
}

.header-breakfast {
  background-color: var(--meal-breakfast); 
}
.header-mainmeal {
  background-color: var(--meal-main); 
}
.header-preworkout {
  background-color: var(--meal-preworkout); 
}
.header-supper {
  background-color: var(--meal-supper); 
}
</style>