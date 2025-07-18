<template>
  <section>
    <div class="header">
      <SearchBar v-model="searchText" placeholder="Search..." />
        <div class="buttons">
            <RevertButton @click="handleRevertButtonClick" :disabled="!hasPendingChanges" />
            <UpdateButton @click="handleUpdateButtonClick" :disabled="!hasPendingChanges" />
        </div>
    </div>
    <DietsTable 
      :items="diets"
      @itemUpdated="handleItemUpdate"
    ></DietsTable>
  </section>
</template>

<script setup lang="ts">
import './PW3_DietsView.style.css'
import SearchBar from '@/components/SearchBar.vue';
import RevertButton from '@/components/RevertButton.vue';
import { useDietsListViewLogic } from '../composables/useDietsListViewLogic'
import UpdateButton from '@/components/UpdateButton.vue';
import DietsTable from '../components/DietsTable.vue';
import { DietShort } from '@/types/types';
import AddButton from '@/components/AddButton.vue';

const {
  diets,
  searchText,
  pendingChanges,
  hasPendingChanges,
  handleItemUpdate,
  handleRevertButtonClick,
  handleUpdateButtonClick,
  handleAddButtonClick,
} = useDietsListViewLogic();
</script>