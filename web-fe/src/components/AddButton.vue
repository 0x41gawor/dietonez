<template>
  <BaseButton class="update-button" @click="$emit('click', $event)">
    <template #icon>
      <!-- Save/Floppy Disk Icon SVG -->
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5M16.5 12L12 16.5m0 0L7.5 12m4.5 4.5V3"
        />
      </svg>
    </template>
    Update
  </BaseButton>
</template>

<script setup>
import BaseButton from './BaseButton.vue';

// Re-emit the click event
defineEmits(['click']);
</script>

<style scoped>
.update-button {
  background-color: var(--btn-add); /* A dark blue/charcoal color */
  color: white;
}

.update-button:hover {
  background-color: #184916; /* A slightly lighter dark color on hover */
}
</style>