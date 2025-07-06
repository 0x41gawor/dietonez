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
          <tr v-if="!foodItems || foodItems.length === 0">
            <td colspan="9" class="empty-state">No items to display.</td>
          </tr>
          <tr v-for="item in foodItems" :key="item.id">
            <td>
              <div class="name-cell">
                <span>{{ item.name }} {{ item.brand ? `(${item.brand})` : '' }}</span>
                <span
                  v-for="tag in item.tags"
                  :key="tag.text"
                  class="tag"
                  :class="tag.className"
                >
                  {{ tag.text }}
                </span>
              </div>
            </td>
            <td>{{ item.defaultAmount }}</td>
            <td>{{ item.unit }}</td>
            <td>{{ item.shopStyle }}</td>
            <td>{{ item.kcal }}</td>
            <td>{{ item.protein }}</td>
            <td>{{ item.fats }}</td>
            <td>{{ item.carbs }}</td>
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
      <span class="footer-info">Showing {{ foodItems.length }} out of 452 elements</span>
      <div class="pagination-controls">
        <button class="pagination-arrow" aria-label="Previous page"><</button>
        <span class="pagination-status">{{ currentPage }} / {{ totalPages }}</span>
        <button class="pagination-arrow" aria-label="Next page">></button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { PropType } from 'vue';

// --- TYPE DEFINITIONS ---
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

// --- PROPS & EMITS ---
defineProps({
  foodItems: {
    type: Array as PropType<FoodItem[]>,
    required: true,
  },
  currentPage: {
    type: Number,
    default: 1,
  },
  totalPages: {
    type: Number,
    default: 1,
  },
});

const emit = defineEmits(['deleteItem']);
</script>

<style scoped>
/* General container styling - MODIFIED */
.table-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  background-color: #ffffff;
  /* Make container a flex column with a fixed height */
  display: flex;
  flex-direction: column;
  height: 680px; /* Fixed height to match the design */
}

/* Table wrapper - MODIFIED */
.table-wrapper {
  /* Allow this area to grow and scroll */
  flex: 1;
  overflow: auto; /* Handles both vertical and horizontal scrolling */
}

table {
  width: 100%;
  border-collapse: collapse;
  min-width: 950px;
}

/* Table Header - MODIFIED */
th {
  padding: 8px 10px;
  text-align: left;
  font-weight: 100;
  color: #666;
  font-size: 0.875rem;
  border-bottom: 1px solid #e0e0e0;
  white-space: nowrap;
  background-color: #f9f9f9;
  /* Make header sticky to the top of the scrollable container */
  position: sticky;
  top: 0;
  z-index: 1;
}

/* Column width definitions */
.col-name { width: 50%; }
.col-numeric { width: 4%; }
.col-text { width: 5%; }
.col-actions { width: 5%; text-align: center; }

/* Table Body */
tbody tr:hover { background-color: #f5f5f5; }
td {
  padding: 4px 10px;  
  border-bottom: 1px solid #e0e0e0;
  color: #333;
  font-size: 0.75rem;
  vertical-align: middle;
}
tbody tr:last-child td { border-bottom: 1px solid #e0e0e0;; }
.empty-state { text-align: center; color: #888; padding: 2rem; }
.name-cell { display: flex; align-items: center; flex-wrap: wrap; gap: 4px 8px; }

/* Tags */
.tag { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 0.6rem; font-weight: 500; }
.tag-probiotic { background-color: #e8e8e8; color: #555; }
.tag-vitamin { background-color: #fff4b1; color: #6d5f00; }
.tag-fiber { background-color: #d4edda; color: #155724; }

/* Action Button */
.action-button { background-color: var(--grey-100); border: none; color: var(--btn-delete); padding: 6px 9px; border-radius: 5px; cursor: pointer; display: inline-flex; transition: background-color 0.2s ease; }
.action-button:hover { color: var(--btn-delete-hover); background-color: var(--grey-200); }
td:last-child { text-align: center; }

/* Footer - MODIFIED */
.table-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 16px;
  border-top: 1px solid #e0e0e0;
  font-size: 0.8rem;
  color: #666;
  /* Prevent the footer from shrinking */
  flex-shrink: 0;
  height: 20px;
}
.pagination-controls { display: flex; align-items: center; gap: 1rem; }
.pagination-arrow { background: none; border: none; cursor: pointer; font-size: 1.2rem; color: #555; }
.pagination-arrow:hover { color: #000; }
</style>