<template>
  <section>
    <div class="header">
      <SearchBar
        v-model="searchText"
        placeholder="Search ingredients..."
      />

      <div class="buttons">
        <button class="btn btn-secondary">Revert</button>
        <button class="btn btn-primary">Update</button>
      </div>
      
    </div>

    <IngredientTable />
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import IngredientTable from '../components/IngredientTable2.vue';
import SearchBar from '@/components/SearchBar.vue'

const searchText = ref('')
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