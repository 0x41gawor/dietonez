<template>
  <button class="base-button" @click="$emit('click', $event)">
    <!-- A slot for an optional icon -->
    <span v-if="$slots.icon" class="icon-wrapper">
      <slot name="icon"></slot>
    </span>
    <!-- The default slot for the button's text -->
    <slot></slot>
  </button>
</template>

<script setup>
// Define that this component can emit a 'click' event
defineEmits(['click']);
</script>

<style scoped>
.base-button {
  /* Flex layout to align icon and text */
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem; /* 8px space between icon and text */

  /* General styling */
  padding: 0.6rem 1.2rem; /* 10px 18px */
  border-radius: 8px;
  border: none;
  cursor: pointer;
  font-family: sans-serif;
  font-size: 0.8rem; 
  font-weight: 500;
  white-space: nowrap;

  /* Smooth transition for hover effects */
  transition: background-color 0.2s ease-in-out, transform 0.1s ease;
}

.base-button:hover {
  /* A subtle visual feedback on hover */
  transform: translateY(-1px);
}

.base-button:active {
  /* A subtle visual feedback on click */
  transform: translateY(0);
}

.icon-wrapper :slotted(svg) {
  /* Style the SVG passed into the slot */
  width: 1.5em; /* Adjust size relative to font */
  height: 1.5em;
  display: block;
}
</style>