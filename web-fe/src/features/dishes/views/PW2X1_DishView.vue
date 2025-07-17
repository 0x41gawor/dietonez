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
        <template v-if="isCreatingNew">
            <CreateButton @click="handleCreateButtonClick" :disabled="!hasNameAndIngredients" />
        </template>
        <template v-else>
            <UpdateButton @click="handleUpdateButtonClick" :disabled="!hasPendingChanges" />
      </template>
      </div>
    </div>
    
    <IngredientsInDishTable
    :items="dish?.ingredients || []"
    :summary="summary"
    @delete-item="handleDeleteItem"
    @update-item="handleUpdateItem"
    />
    <AddRow :loading="isAddingIngredient" :used-ingredients="dish.ingredients" @add-ingredient="handleAddNewIngredient" />
    <Recipe :recipe="dish.recipe" v-model:has-pending-changes="hasPendingChanges"/>
    <div class="delete-button-wrapper">
        <DeleteButton @click="handleDeleteButtonClick" :disabled="isCreatingNew"/>
    </div>

    <Modal v-if="showDeleteModal" @close="showDeleteModal = false">
  <template #title>Confirm Deletion</template>
  <template #body>
    Are you sure you want to delete this dish? This action cannot be undone.
  </template>
  <template #footer>
    <button @click="showDeleteModal = false" class="btn cancel">Nie</button>
    <button @click="confirmDelete" class="btn delete">Tak</button>
  </template>
</Modal>
  
  </section>
</template>

<script setup lang="ts">
import './PW2X1_DishView.style.css'
import { useDishViewLogic } from '../composables/useDishViewLogic';
import { toRef } from 'vue';
import AddRow  from '../components/AddRow.vue';
import Recipe from '../components/Recipe.vue';
import UpdateButton from '@/components/UpdateButton.vue';
import CreateButton from '@/components/CreateButton.vue';
import RevertButton from '@/components/RevertButton.vue';
import DeleteButton from '@/components/DeleteButton.vue';
import Modal from '@/components/Modal.vue'
import IngredientsInDishTable from '../components/IngredientsInDishTable.vue';
import { Meal } from '@/types/types';

const props = defineProps<{
  id: number
  meal: Meal 
}>()

const id = toRef(props, 'id')
const meal = toRef(props, 'meal')


const {
    dish,
    summary,
    hasPendingChanges,
    hasNameAndIngredients,
    handleDeleteItem,
    handleUpdateItem,
    handleRevertButtonClick,
    handleUpdateButtonClick,
    handleCreateButtonClick,
    handleDeleteButtonClick,
    isAddingIngredient,
    handleAddNewIngredient,
    showDeleteModal,
    confirmDelete,
    isCreatingNew,
} = useDishViewLogic(id, meal.value);
</script>