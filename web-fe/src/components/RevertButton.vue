<template>
  <BaseButton class="revert-button" @click="$emit('click', $event)">
    <template #icon>
      <!-- Revert/Undo Icon SVG -->
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
          d="M9 15L3 9m0 0l6-6M3 9h12a6 6 0 010 12h-3"
        />
      </svg>
    </template>
    Revert
  </BaseButton>
</template>

<script setup>
import BaseButton from './BaseButton.vue';

// Re-emit the click event from the BaseButton for the parent to catch
defineEmits(['click']);
</script>

<style scoped>
/*
  We use a class on the root of our component.
  Because the styles are scoped, Vue will add a unique data-attribute,
  ensuring these styles only apply to this component's BaseButton instance.
*/
.revert-button {
  background-color: var(--btn-revert);
  color: white;
}

.revert-button:hover {
  background-color: #4a627a;
}
</style>