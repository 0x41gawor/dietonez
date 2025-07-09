<template>
  <div class="search-bar">
    <!-- Ikona SVG -->
    <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" fill="none"
         viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round"
            d="M21 21l-4.35-4.35m0 0A7.5 7.5 0 103.75 3.75a7.5 7.5 0 0012.9 12.9z" />
    </svg>

    <!-- Pole wyszukiwania -->
    <input
      type="text"
      class="search-input"
      :placeholder="placeholder"
      :value="modelValue"
      @input="onInput"
    />
  </div>
</template>



<script setup lang="ts">
const props = defineProps<{
  modelValue?: string
  placeholder?: string
}>();

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>();

function onInput(e: Event) {
  const target = e.target as HTMLInputElement | null;
  if (target) {
    emit('update:modelValue', target.value);
  }
}
</script>

<style scoped>
.search-bar {
  position: relative;
  font-size: 1rem;
}

.search-input {
  width: 100%;
  padding: 0.5rem 1rem 0.5rem 2.5rem; /* miejsce na ikonę po lewej */
  border: 1px solid var(--color-grey-light);
  border-radius: var(--radius);
  font-size: 0.85rem;
  transition: box-shadow 0.2s ease, border-color 0.2s ease;
}

.search-input:focus {
  outline: none;
  border-color: var(--color-grey-900);
}

.search-icon {
  position: absolute;
  left: 0.8rem;
  top: 50%;
  transform: translateY(-50%);
  width: 1rem;
  height: 1rem;
  margin-top: 0.035rem;
  color: var(--color-grey-dark);
  pointer-events: none;
}
</style>

