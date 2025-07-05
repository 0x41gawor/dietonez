<template>
  <section>
    <Breadcrumb :items="['Home', 'Ingredients']" />

    <div class="header">
      <h1>Ingredients</h1>
      <div class="buttons">
        <button class="btn btn-secondary">Revert</button>
        <button class="btn btn-primary">Update</button>
      </div>
    </div>

    <IngredientTable />

    <!-- Tu później dodamy: paginację, pasek Add -->
  </section>
</template>

<script setup lang="ts">
import IngredientTable from '../components/IngredientTable.vue';
import Breadcrumb from '@/components/Breadcrumb.vue'; // za chwilę stworzymy
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
  border-radius: var(--radius);
  font-weight: 500;
  cursor: pointer;
  border: none;
}

.btn-secondary {
  background-color: var(--btn-update);
  color: white;
}

.btn-primary {
  background-color: var(--btn-add);
  color: white;
}
</style>
    