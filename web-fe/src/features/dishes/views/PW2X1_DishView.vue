<template>
  <section>
    <div class="header">
      <div class="buttons">
        {{  dish?.name }}
        <!-- <RevertButton @click="" :disabled="!hasPendingChanges" />  -->
        <!-- <UpdateButton @click="" :disabled="!hasPendingChanges" /> -->
      </div>
    </div>
    <!-- <AddRow :loading="isAddingIngredient" @add-ingredient="handleAddNewIngredient" /> -->

      <IngredientsInDishTable
        :items="dish?.ingredients || []"
      />
  </section>
</template>

<script setup lang="ts">
import './PW2X1_DishView.style.css'
import { useDishViewLogic } from '../composables/useDishViewLogic';
import UpdateButton from '@/components/UpdateButton.vue';
import RevertButton from '@/components/RevertButton.vue';
import IngredientsInDishTable from '../components/IngredientsInDishTable.vue';
import { onMounted } from 'vue';

const {id} = defineProps<{ id: number }>()


const {
    dish
} = useDishViewLogic(id);
</script>