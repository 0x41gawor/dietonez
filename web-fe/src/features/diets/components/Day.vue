<template>
  <div class="day-card">
    <h2 class="day-header">{{ day.name }}</h2>

    <div
      v-for="(slot, index) in day.slots"
      :key="index"
      class="slot-wrapper"
    >
      <div class="slot-header" :style="getSlotStyle(slot.meal)">
        <span class="meal-name">{{ slot.meal.replace('-', ' ') }}</span>
        <select
          class="dish-select"
          :style="getSlotStyle(slot.meal)"
          @change="handleDishChange(index, $event)"
        >
          <option v-if="!slot.dish" :value="null" selected disabled>
            Wybierz danie...
          </option>
          <option v-if="slot.dish" :value="slot.dish.id" selected disabled>
            {{ slot.dish.name }}
          </option>
          
          <option
            v-for="option in getOptionsForMeal(slot.meal)"
            :key="option.id"
            :value="option.id"
          >
            {{ option.name }}
          </option>
        </select>
      </div>

      <div class="nutrition-grid">
        <span class="cell">{{ formatNumber(slot.dish?.kcal) }}</span>
        <span class="cell">{{ formatNumber(slot.dish?.protein) }}</span>
        <span class="cell">{{ formatNumber(slot.dish?.fat) }}</span>
        <span class="cell">{{ formatNumber(slot.dish?.carbs) }}</span>
      </div>
    </div>

    <div class="summary">
      <span class="summary-label">Summary ({{ formatNumber(day.summary.goal) }} kcal)</span>
      <div class="nutrition-grid">
        <span class="cell">{{ formatNumber(day.summary.kcal) }}</span>
        <span class="cell">{{ formatNumber(day.summary.proteins) }}</span>
        <span class="cell">{{ formatNumber(day.summary.fats) }}</span>
        <span class="cell">{{ formatNumber(day.summary.carbs) }}</span>
      </div>
    </div>

    <div class="left">
      <span class="left-label">Kcal left</span>
      <div class="nutrition-grid">
        <span class="cell">{{ formatNumber(day.left.kcal) }}</span>
        <span class="cell">{{ formatNumber(day.left.proteins) }}</span>
        <span class="cell">{{ formatNumber(day.left.fats) }}</span>
        <span class="cell"></span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">

import type { DishGetShort, SlotGet, Summary, Left, DayGet} from '@types/types';

// --- PROPSY KOMPONENTU ---
const props = defineProps<{
  day: DayGet;
  // Poniższe propsy odpowiadają opcjom dla DishType
  breakfastOptions: DishGetShort[];
  mainMealOptions: DishGetShort[];
  preWorkoutOptions: DishGetShort[];
  supperOptions: DishGetShort[];
}>();

// --- EMITY ZDARZEŃ ---
const emit = defineEmits<{
  (e: 'update-slot', payload: { slotIndex: number; newDishId: number }): void;
}>();


// --- FUNKCJE POMOCNICZE ---

/**
 * Mapuje porę posiłku (Meal) na odpowiednie opcje dań (DishType).
 * Lunch i Post-Workout korzystają z opcji MainMeal.
 */
const getOptionsForMeal = (mealType: Meal): DishGetShort[] => {
  switch (mealType) {
    case 'Breakfast':
      return props.breakfastOptions;
    case 'Lunch':
    case 'Post-Workout':
      return props.mainMealOptions; // Kluczowa zmiana
    case 'PreWorkout': // 'Pre-Workout' z myślnikiem to nazwa Meal, 'PreWorkout' bez to DishType
      return props.preWorkoutOptions;
    case 'Supper':
      return props.supperOptions;
    default:
      return [];
  }
};

/**
 * Zwraca styl dla czcionki na podstawie pory posiłku (Meal).
 */
const getSlotStyle = (mealType: Meal) => {
  const colorMap: Partial<Record<Meal, string>> = {
    Breakfast: '#e8b478',
    Lunch: '#e48e8e', // Kolor jak dla MainMeal
    PreWorkout: '#79c0e0',
    'Post-Workout': '#e48e8e', // Kolor jak dla MainMeal
    Supper: '#78c8a0',
  };
  return { color: colorMap[mealType] || '#000000' };
};

const handleDishChange = (slotIndex: number, event: Event) => {
  const target = event.target as HTMLSelectElement;
  const newDishId = parseInt(target.value, 10);
  emit('update-slot', { slotIndex, newDishId });
};

// Funkcja do formatowania liczb z wieloma miejscami po przecinku
const formatNumber = (num: number | undefined | null) => {
    if (num === undefined || num === null) return 0;
    return Math.round(num);
}
</script>

<style scoped>
.day-card {
  background-color: #ffffff;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 16px;
  font-family: Arial, sans-serif;
  color: #000000;
  width: 100%;
  max-width: 450px;
}

.day-header {
  font-weight: bold;
  text-align: center;
  margin-bottom: 16px;
  font-size: 1.2em;
  text-transform: capitalize;
}

.slot-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}
.slot-wrapper:last-of-type {
  border-bottom: none;
}

.slot-header {
    display: flex;
    flex-direction: column;
    width: 55%;
    font-weight: bold;
}

.meal-name {
    font-size: 0.8em;
    opacity: 0.7;
    margin-bottom: 4px;
}

.dish-select {
  font-weight: bold;
  font-size: 1em;
  border: none;
  background-color: transparent;
  cursor: pointer;
  width: 100%;
  padding: 0;
}

.dish-select:focus {
  outline: none;
}

.summary, .left {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 12px;
  padding: 8px;
  border-radius: 4px;
  font-weight: bold;
}

.summary {
  background-color: #f5f5f5;
}
.left {
    background-color: #fafafa;
}

.summary-label, .left-label {
    width: 55%;
}

.nutrition-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
  text-align: center;
  width: 45%;
}

.cell {
  font-size: 0.9em;
}
</style>