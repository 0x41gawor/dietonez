<template>
  <div class="table-container">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>D. Amount</th>
            <th>Unit</th>
            <th>Shop-style</th>
            <th>Kcal</th>
            <th>Prot.</th>
            <th>Fats</th>
            <th>Carb.</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
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
              <button class="action-button" @click="deleteItem(item.id)" aria-label="Delete item">
                <!-- Embedded SVG for trash icon -->
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
      <span class="footer-info">Showing 100 out of 452 elements</span>
      <div class="pagination-controls">
        <button class="pagination-arrow" aria-label="Previous page"><</button>
        <span class="pagination-status">{{ currentPage }} / {{ totalPages }}</span>
        <button class="pagination-arrow" aria-label="Next page">></button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

// --- TYPE DEFINITIONS ---
interface Tag {
  text: string;
  className: string; // Used to apply specific CSS classes for colors
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

// --- MOCK DATA ---
// Data is mocked based on the provided image.
const foodItems = ref<FoodItem[]>([
  {
    id: 1,
    name: "Rolada ustrzycka",
    brand: "Regionalne Szlaki",
    tags: [
      { text: "probiotyk", className: "tag-probiotic" },
      { text: "witamina C", className: "tag-vitamin" },
      { text: "błonnik", className: "tag-fiber" },
    ],
    defaultAmount: 100, unit: "g", shopStyle: "Zapasy", kcal: 326, protein: 28, fats: 28, carbs: 12,
  },
  {
    id: 2,
    name: "Filet z piersi kurczaka",
    brand: "Kraina Mięs",
    defaultAmount: 100, unit: "Opakowanie", shopStyle: "Lidl", kcal: 432, protein: 13, fats: 12, carbs: 8.9,
  },
  {
    id: 3,
    name: "Kefir",
    brand: "Robico",
    defaultAmount: 100, unit: "Łyżka", shopStyle: "G.S.", kcal: 123, protein: 8.9, fats: 1, carbs: 45,
  },
  {
    id: 4,
    name: "Serek wiejski wysokobiałkowy",
    brand: "OSM Siedlce",
    defaultAmount: 100, unit: "g", shopStyle: "Lidl", kcal: 34, protein: 12, fats: 3.2, carbs: 12,
  },
  {
    id: 5,
    name: "Burger Wołowy",
    brand: "Rzeźnik",
    defaultAmount: 100, unit: "g", shopStyle: "Świeże", kcal: 124, protein: 21, fats: 45, carbs: 56,
  },
  {
    id: 6,
    name: "Oliwa z oliwek",
    defaultAmount: 100, unit: "Porcja", shopStyle: "Zapasy", kcal: 765, protein: 1, fats: 6, carbs: 5.4,
  },
  {
    id: 7,
    name: "Tortilla pszenna wraps",
    brand: "PANO",
    defaultAmount: 100, unit: "Łyżeczka", shopStyle: "Lidl", kcal: 8, protein: 28, fats: 3.4, carbs: 96,
  },
  {
    id: 8,
    name: "Czosnek świeży",
    defaultAmount: 100, unit: "g", shopStyle: "Lidl", kcal: 12, protein: 4, fats: 87, carbs: 34,
  },
]);

// --- PAGINATION STATE ---
const currentPage = ref(12);
const totalPages = ref(20);

// --- METHODS ---
const deleteItem = (id: number) => {
  // In a real application, you would emit an event or call an API here.
  alert(`Delete item with ID: ${id}`);
};
</script>

<style scoped>
/* General container styling */
.table-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
  background-color: #ffffff;
}

/* Wrapper to allow for horizontal scrolling on smaller screens */
.table-wrapper {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  min-width: 900px; /* Ensures table layout is maintained on smaller viewports */
}

/* Table Header */
thead tr {
  background-color: #f9f9f9;
}

th {
  padding: 12px 16px;
  text-align: left;
  font-weight: 600;
  color: #666;
  font-size: 0.875rem;
  border-bottom: 1px solid #e0e0e0;
  white-space: nowrap;
}

/* Table Body */
tbody tr:hover {
  background-color: #f5f5f5;
}

td {
  padding: 12px 16px;
  border-bottom: 1px solid #e0e0e0;
  color: #333;
  font-size: 0.9rem;
  vertical-align: middle;
}

/* Remove bottom border for the last row */
tbody tr:last-child td {
  border-bottom: none;
}

/* Name column specifics */
.name-cell {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 4px 8px;
}

.tag {
  display: inline-block;
  padding: 3px 10px;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 500;
  line-height: 1.2;
}

/* Tag colors based on the image */
.tag-probiotic {
  background-color: #e8e8e8;
  color: #555;
}
.tag-vitamin {
  background-color: #fff4b1;
  color: #6d5f00;
}
.tag-fiber {
  background-color: #d4edda;
  color: #155724;
}

/* Actions column button */
.action-button {
  background-color: #dc3545;
  border: none;
  color: white;
  padding: 6px 9px;
  border-radius: 5px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.2s ease;
}

.action-button:hover {
  background-color: #c82333;
}

/* Table Footer */
.table-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background-color: #ffffff;
  border-top: 1px solid #e0e0e0;
  font-size: 0.875rem;
  color: #666;
}

.pagination-controls {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.pagination-arrow {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.2rem;
  color: #555;
  padding: 0 4px;
}

.pagination-arrow:hover {
  color: #000;
}
</style>