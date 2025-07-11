<template>
  <section>
    <div class="header">
      <SearchBar v-model="searchText" placeholder="Search..." />
      <div class="buttons">
        <RevertButton @click="handleRevertButtonClick" :disabled="!hasPendingChanges" /> 
        <UpdateButton @click="handleUpdateButtonClick" :disabled="!hasPendingChanges" />
      </div>
    </div>

    <IngredientTable 
      :ingredients="ingredients"
      :current-page="1"
      :total-pages="totalPages"
      :page-size="pageSize"
      :page="page"
      :total="total"
      @delete-item="handleDeleteItem"
      @item-updated="handleItemUpdate"
      @pageSizeChanged="handlePageSizeUpdate"
      @pageChanged="handlePageChange"
    />

    <AddRow :loading="isAddingIngredient" @add-ingredient="handleAddNewIngredient" />
  </section>
</template>

<script setup lang="ts">
import './IngredientsView.style.css'
import { useIngredientsLogic } from '../composables/useIngredientsViewLogic'
import SearchBar from '@/components/SearchBar.vue';
import RevertButton from '@/components/RevertButton.vue';
import UpdateButton from '@/components/UpdateButton.vue';
import IngredientTable from '../components/IngredientTable.vue';
import AddRow from '../components/AddRow.vue';

const {
  ingredients,
  total,
  page,
  pageSize,
  totalPages,
  isAddingIngredient,
  searchText,
  hasPendingChanges,
  handleItemUpdate,
  handleRevertButtonClick,
  handleUpdateButtonClick,
  handleDeleteItem,
  handleAddNewIngredient,
  handlePageSizeUpdate,
  handlePageChange
} = useIngredientsLogic();
</script>