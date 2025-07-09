<template>
  <BaseButton class="add-button" @click="$emit('click', $event)">
    <template #icon>
      <!-- Save/Floppy Disk Icon SVG -->
      <svg
    xmlns="http://www.w3.org/2000/svg"
    fill="none"
    viewBox="0 0 24 24"
    stroke-width="1.5"
    stroke="currentColor"
    class="icon"
  >
     <path
    stroke-linecap="round"
    stroke-linejoin="round"
    d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
  />
  </svg>
    </template>
    Add
  </BaseButton>
</template>

<script setup>
import BaseButton from './BaseButton.vue';

// Re-emit the click event
defineEmits(['click']);
</script>

<style scoped>
.add-button {
  background-color: var(--btn-add); /* A dark blue/charcoal color */
  color: white;
}

.add-button:hover {
  background-color: #184916; /* A slightly lighter dark color on hover */
}
</style>