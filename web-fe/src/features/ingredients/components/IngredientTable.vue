<template>
  <div class="ingredient-table">
    <!-- Tabela -->
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>D. Amount</th>
          <th>Unit</th>
          <th>Shop-style</th>
          <th>Kcal</th>
          <th>Prot</th>
          <th>Fats</th>
          <th>Carb</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="ingredient in filteredIngredients" :key="ingredient.id">
          <td>
            <span>{{ ingredient.name }}</span>
            <span
              v-for="tag in ingredient.tags"
              :key="tag"
              class="tag"
            >
              {{ tag }}
            </span>
          </td>
          <td>{{ ingredient.amount }}</td>
          <td>{{ ingredient.unit }}</td>
          <td>{{ ingredient.shopStyle }}</td>
          <td>{{ ingredient.kcal }}</td>
          <td>{{ ingredient.protein }}</td>
          <td>{{ ingredient.fat }}</td>
          <td>{{ ingredient.carbs }}</td>
          <td>
            <button class="delete-btn">🗑</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Info + Add button -->
    <div class="footer">
      <span>Showing {{ filteredIngredients.length }} out of {{ ingredients.length }} elements</span>
      <button class="add-btn">➕ Add</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

interface Ingredient {
  id: number;
  name: string;
  tags: string[];
  amount: string;
  unit: string;
  shopStyle: string;
  kcal: number;
  protein: number;
  fat: number;
  carbs: number;
}

const search = ref('');
const ingredients = ref<Ingredient[]>([
  {
    id: 1,
    name: 'Rolada ustrzycka (Regionalne Szlaki)',
    tags: ['probiotyk', 'witamina D', 'błonnik'],
    amount: '100',
    unit: 'g',
    shopStyle: 'Zapasy',
    kcal: 326,
    protein: 28,
    fat: 28,
    carbs: 12,
  },
  {
    id: 2,
    name: 'Rolada ustrzycka (Regionalne Szlaki)',
    tags: ['probiotyk', 'witamina D', 'błonnik'],
    amount: '100',
    unit: 'g',
    shopStyle: 'Zapasy',
    kcal: 326,
    protein: 28,
    fat: 28,
    carbs: 12,
  },
  {
    id: 3,
    name: 'Rolada ustrzycka (Regionalne Szlaki)',
    tags: ['probiotyk', 'witamina D', 'błonnik'],
    amount: '100',
    unit: 'g',
    shopStyle: 'Zapasy',
    kcal: 326,
    protein: 28,
    fat: 28,
    carbs: 12,
  },
]);

const filteredIngredients = computed(() =>
  ingredients.value.filter(i =>
    i.name.toLowerCase().includes(search.value.toLowerCase())
  )
);
</script>

<style scoped>
.ingredient-table {
  margin-top: 1rem;
}

.search-bar {
  width: 300px;
  padding: 0.5rem;
  margin-bottom: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead th {
  background-color: #f5f5f5;
  padding: 0.5rem;
  text-align: left;
}

td {
  padding: 0.5rem;
  border-bottom: 1px solid #eee;
}

.tag {
  background-color: #dff0d8;
  color: #3c763d;
  font-size: 0.75rem;
  padding: 0.2rem 0.4rem;
  margin-left: 0.4rem;
  border-radius: 4px;
  display: inline-block;
}

.delete-btn {
  background-color: #ef4545;
  color: white;
  border: none;
  padding: 0.3rem 0.6rem;
  border-radius: 4px;
  cursor: pointer;
}

.add-btn {
  background-color: #4caf50;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  margin-left: auto;
  display: block;
  cursor: pointer;
}

.footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 1rem;
}
</style>
