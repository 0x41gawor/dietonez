<template>
  <section>
    <div class="header">
      <input
        v-if="dish"
        v-model="dish.name"
        @input="hasPendingChanges = true"
        :class="['dish-title-input', 'meal--' + dish?.meal]"
        placeholder="Dish name"
      />
      <div class="buttons">
        <RevertButton @click="handleRevertButtonClick" :disabled="!hasPendingChanges" />
        <UpdateButton @click="handleUpdateButtonClick" :disabled="!hasPendingChanges" />
      </div>
    </div>

    <!-- <AddRow :loading="isAddingIngredient" @add-ingredient="handleAddNewIngredient" /> -->

      <IngredientsInDishTable
        :items="dish?.ingredients || []"
        @delete-item="handleDeleteItem"
        @update-item="handleUpdateItem"
      />
  </section>
</template>

<script setup lang="ts">
import './PW2X1_DishView.style.css'
import { useDishViewLogic } from '../composables/useDishViewLogic';
import UpdateButton from '@/components/UpdateButton.vue';
import RevertButton from '@/components/RevertButton.vue';
import IngredientsInDishTable from '../components/IngredientsInDishTable.vue';

const {id} = defineProps<{ id: number }>()


const {
    dish,
    hasPendingChanges,
    handleDeleteItem,
    handleUpdateItem,
    handleRevertButtonClick,
    handleUpdateButtonClick
} = useDishViewLogic(id);
</script>