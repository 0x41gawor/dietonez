<template>
  <section>
    <div class="header">
      <div class="buttons">
        <RevertButton @click="handleRevertButtonClick" :disabled="!hasPendingChanges" /> 
        <UpdateButton @click="handleUpdateButtonClick" :disabled="!hasPendingChanges" />
      </div>
    </div>

    <DietContextCard :context="dietContext" />
  </section>
</template>

<script setup lang="ts">
import './HomeView.style.css'
import DietContextCard from '../components/DietContextCard.vue' // lub DietContextCard.vue, jeśli tak się nazywa
import { useHomeViewLogic } from '../composables/useHomeViewLogic'
import RevertButton from '@/components/RevertButton.vue'
import UpdateButton from '@/components/UpdateButton.vue'


const {
  dietContext,
  hasPendingChanges,
  handleRevertButtonClick,
  handleUpdateButtonClick
 } = useHomeViewLogic()
</script>
