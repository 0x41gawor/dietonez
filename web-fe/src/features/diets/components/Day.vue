<template>
  <div class="day-card">

    <!-- BREAKFAST -->
    <div class="slot-wrapper">
      <div class="slot-header" :style="getSlotStyle('Breakfast')">
      <select
          class="dish-select"
          :value="day.slots[0].dish?.id ?? null"
          :style="getSlotStyle('Breakfast')" 
          @change="handleDishChange(0, $event)"
        >
          <option disabled value=""></option>
          <option
            v-for="option in getOptionsForMeal('Breakfast')"
            :key="option.id"
            :value="option.id"
          > 
           {{option.name}}
          </option>
        </select>
      </div>
      <div class="nutrition-grid">
        <span class="cell">{{ formatNumber(findSlot('Breakfast')?.dish?.kcal) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Breakfast')?.dish?.protein) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Breakfast')?.dish?.fat) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Breakfast')?.dish?.carbs) }}</span>
      </div>
    </div>

    <!-- LUNCH -->
    <div class="slot-wrapper">
      <div class="slot-header" :style="getSlotStyle('Lunch')">
        <select
          class="dish-select"
          :value="day.slots[1].dish?.id ?? null"
          :style="getSlotStyle('Lunch')" 
          @change="handleDishChange(1, $event)"
        >
          <option disabled value=""></option>
          <option
            v-for="option in getOptionsForMeal('Lunch')"
            :key="option.id"
            :value="option.id"
          > 
           {{option.name}}
          </option>
        </select>
      </div>
      <div class="nutrition-grid">
        <span class="cell">{{ formatNumber(findSlot('Lunch')?.dish?.kcal) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Lunch')?.dish?.protein) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Lunch')?.dish?.fat) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Lunch')?.dish?.carbs) }}</span>
      </div>
    </div>

    <!-- PRE-WORKOUT -->
    <div class="slot-wrapper">
      <div class="slot-header" :style="getSlotStyle('Pre-Workout')">
        <select
          class="dish-select"
          :value="day.slots[2].dish?.id ?? null"
          :style="getSlotStyle('Pre-Workout')" 
          @change="handleDishChange(2, $event)"
        >
          <option disabled value=""></option>
          <option
            v-for="option in getOptionsForMeal('Pre-Workout')"
            :key="option.id"
            :value="option.id"
          > 
           {{option.name}}
          </option>
        </select>
      </div>
      <div class="nutrition-grid">
        <span class="cell">{{ formatNumber(findSlot('Pre-Workout')?.dish?.kcal) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Pre-Workout')?.dish?.protein) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Pre-Workout')?.dish?.fat) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Pre-Workout')?.dish?.carbs) }}</span>
      </div>
    </div>

    <!-- POST-WORKOUT -->
    <div class="slot-wrapper">
      <div class="slot-header" :style="getSlotStyle('Post-Workout')">
        <select
          class="dish-select"
          :value="day.slots[3].dish?.id ?? null"
          :style="getSlotStyle('Post-Workout')" 
          @change="handleDishChange(3, $event)"
        >
          <option disabled value=""></option>
          <option
            v-for="option in getOptionsForMeal('Post-Workout')"
            :key="option.id"
            :value="option.id"
          > 
           {{option.name}}
          </option>
        </select>
      </div>
      <div class="nutrition-grid">
        <span class="cell">{{ formatNumber(findSlot('Post-Workout')?.dish?.kcal) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Post-Workout')?.dish?.protein) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Post-Workout')?.dish?.fat) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Post-Workout')?.dish?.carbs) }}</span>
      </div>
    </div>

    <!-- SUPPER -->
    <div class="slot-wrapper">
      <div class="slot-header" :style="getSlotStyle('Supper')">
        <select
          class="dish-select"
          :value="day.slots[4].dish?.id ?? null"
          :style="getSlotStyle('Supper')" 
          @change="handleDishChange(4, $event)"
        >
          <option disabled value=""></option>
          <option
            v-for="option in getOptionsForMeal('Supper')"
            :key="option.id"
            :value="option.id"
          > 
           {{option.name}}
          </option>
        </select>
      </div>
      <div class="nutrition-grid">
        <span class="cell">{{ formatNumber(findSlot('Supper')?.dish?.kcal) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Supper')?.dish?.protein) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Supper')?.dish?.fat) }}</span>
        <span class="cell">{{ formatNumber(findSlot('Supper')?.dish?.carbs) }}</span>
      </div>
    </div>

    <!-- PODSUMOWANIE -->
    <div class="summary">
      <span class="summary-label"> Goal: {{ formatNumber(day.summary.goal) }}</span>
      <div class="nutrition-grid-summary">
        <span class="cell">{{ formatNumber(day.summary.kcal) }}</span>
        <span class="cell">{{ formatNumber(day.summary.proteins) }}</span>
        <span class="cell">{{ formatNumber(day.summary.fats) }}</span>
        <span class="cell">{{ formatNumber(day.summary.carbs) }}</span>
      </div>
    </div>
    <!-- Left -->
    <div class="left">
      <span>
        Kcal left: <strong>{{ formatNumber(day.left.kcal) }}</strong>, 
        protein: <strong>{{ formatNumber(day.left.proteins,2) }}</strong> [g/kg], 
        fats: <strong>{{ formatNumber(day.left.fats*100,1) }}</strong>[%]
      </span>
    </div>
  </div>
</template>


<script setup lang="ts">

import { DishGetShort, SlotGet, Summary, Left, DayGet, Meal} from '@/types/types';

const MEALS: Meal[] = ['Breakfast', 'Lunch', 'Pre-Workout', 'Post-Workout', 'Supper'];

const findSlot = (meal: Meal) => props.day.slots.find(s => s.meal === meal);

// --- PROPSY KOMPONENTU ---
const props = defineProps<{
  day: DayGet;
  dishOptions: Record<string, DishGetShort[]>
}>();

// --- EMITY ZDARZEŃ ---
const emit = defineEmits<{
  (e: 'update-slot', payload: { dayIndex: number, slotIndex: number; newDishId: number }): void;
}>();


// --- FUNKCJE POMOCNICZE ---

/**
 * Mapuje porę posiłku (Meal) na odpowiednie opcje dań (DishType).
 * Lunch i Post-Workout korzystają z opcji MainMeal.
 */
const getOptionsForMeal = (mealType: Meal): DishGetShort[] => {
  switch (mealType) {
    case 'Breakfast':
      return props.dishOptions['Breakfast'];
    case 'Lunch':
    case 'Post-Workout':
      return props.dishOptions['MainMeal']; 
    case 'Pre-Workout': // 'Pre-Workout' z myślnikiem to nazwa Meal, 'PreWorkout' bez to DishType
      return props.dishOptions['Pre-Workout']; 
    case 'Supper':
      return props.dishOptions['Supper'];
    default:
      return [];
  }
};

/**
 * Zwraca styl dla czcionki na podstawie pory posiłku (Meal).
 */
const getSlotStyle = (mealType: Meal) => {
  const colorMap: Partial<Record<Meal, string>> = {
    'Breakfast': '#ca984d',
    'Lunch': '#e62b58', // Kolor jak dla MainMeal
    'Pre-Workout': '#379acd',
    'Post-Workout': '#e62b58', // Kolor jak dla MainMeal
    'Supper': '#529c64',
  };
  return { color: colorMap[mealType] || '#000000' };
};

const handleDishChange = (slotIndex: number, event: Event) => {
  const target = event.target as HTMLSelectElement;
  const newDishId = parseInt(target.value, 10);
  const dayName = props.day.name;
    // DayName → Index (1-based)
  const dayNameToIndex: Record<string, number> = {
    Monday: 0,
    Tuesday: 1,
    Wednesday: 2,
    Thursday: 3,
    Friday: 4,
    Saturday: 5,
  };
  const dayIndex = dayNameToIndex[dayName]
  emit('update-slot', { dayIndex, slotIndex, newDishId });
};

const formatNumber = (num: number | undefined | null, decimalPlaces?: number): string => {
  if (num === undefined || num === null) return '0';
  if (!decimalPlaces || decimalPlaces <= 0) {
    return Math.round(num).toString();
  }
  return num.toFixed(decimalPlaces);
};

</script>

<style scoped>
.day-card {
  margin: 0; /* zapobiegawczo */
  border-right: 1px solid #e0e0e0;
  border-left: 1px solid #e0e0e0;
  border-top: none;
  border-bottom: none;
  border-radius: 0; /* żeby się ładnie skleiło z sąsiadami */
  font-size: 0.9rem; /* cała karta mniejsza */
}
.day-card:first-child {
  border-left: none;
}
.day-card:last-child {
  border-right: none;
}

.slot-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 2px 2px;
  border-bottom: 1px solid #f0f0f0;
  min-height: 18px; /* stała wysokość slotu */
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
  font-size: 0.9em;
  font-weight: 100;
  border: none;
  background-color: transparent;
  cursor: pointer;
  width: 95%;
  border-radius: 2px;
  padding: 0;
  appearance: none; /* najważniejsze */
  -webkit-appearance: none; /* Safari/Chrome */
  -moz-appearance: none; /* Firefox */
  background-image: none; /* dla pewności */
}

.dish-select:focus {
  outline: none;
}

.summary, .left {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 2px;
  padding: 2px;
  font-size: 0.8rem;
}

.summary {
  background-color: #f5f5f5;
}
.left {
    background-color: #fafafa;
    color: #777;
}

.summary-label {
    width: 55%;
    color: #555;
}


.nutrition-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  text-align: center;
  width: 45%;
}

.nutrition-grid-summary {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  text-align: center;
  width: 45%;
  font-weight: bold;
}

.cell {
  font-size: 0.7em;
}
</style>