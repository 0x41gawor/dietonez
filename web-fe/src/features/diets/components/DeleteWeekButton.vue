<template>
  <BaseButton class="delete-week-button" @click="$emit('click', $event)">
    <template #icon>
      <!-- Minus Icon SVG -->
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
        class="w-5 h-5"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M19.5 12h-15"
        />
      </svg>
    </template>
    Week
  </BaseButton>
</template>



<script setup>
import BaseButton from '@/components/BaseButton.vue'

// Re-emit the click event
defineEmits(['click']);
</script>

<style scoped>
.delete-week-button {
  background-color: var(--btn-delete); /* A dark blue/charcoal color */
  color: white;
}

.delete-week-button:hover {
  background-color: var(--btn-hover);
}
</style>