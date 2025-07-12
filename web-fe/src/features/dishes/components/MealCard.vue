<template>
  <div class="meal-card" :class="variant" @click="$emit('click')">
    <div class="icon">
      <slot name="icon" />
    </div>
    <div class="label">
      <slot name="label" />
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  variant?: 'breakfast' | 'main-meal' | 'pre-workout' | 'supper'
}>()

defineEmits<{
  (e: 'click'): void
}>()
</script>

<style scoped>
.meal-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  padding: 1rem;
  cursor: pointer;
  width: 360px;
  height: 150px;
  color: white;
  transition: transform 0.1s ease;
}
.meal-card:hover {
  transform: scale(1.02);
}

.icon {
  margin-bottom: 0.5rem;
}
.label {
  font-size: 2rem;
  font-weight: 100;
}

/* Color variants */
.breakfast {
  background-color: var(--meal-breakfast);
}
.main-meal {
  background-color: var(--meal-main);
}
.pre-workout {
  background-color: var(--meal-preworkout);
}
.supper {
  background-color: var(--meal-supper);
}
</style>