<template>
  <section>
    <div class="header">
      <div class="buttons">
        {{  dish?.name }}
        <!-- <RevertButton @click="" :disabled="!hasPendingChanges" />  -->
        <!-- <UpdateButton @click="" :disabled="!hasPendingChanges" /> -->
      </div>
    </div>
    />
    <!-- <AddRow :loading="isAddingIngredient" @add-ingredient="handleAddNewIngredient" /> -->
  </section>
</template>

<script setup lang="ts">
import './PW2X1_DishView.style.css'
import { useDishViewLogic } from '../composables/useDishViewLogic';
import UpdateButton from '@/components/UpdateButton.vue';
import RevertButton from '@/components/RevertButton.vue';

const {dishId} = defineProps<{ dishId: number }>()

const {
    dish
} = useDishViewLogic(dishId);
</script>