<template>
  <BaseButton class="add-week-button" @click="$emit('click', $event)">
    <template #icon>
      <!-- Plus Icon SVG -->
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
          d="M12 4.5v15m7.5-7.5h-15"
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
.add-week-button {
  background-color: var(--btn-add); /* A dark blue/charcoal color */
  color: white;
}

.add-week-button:hover {
  background-color: #2d3748; /* A slightly lighter dark color on hover */
}
</style>