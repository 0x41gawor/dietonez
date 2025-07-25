<template>
  <div class="week-container">
     <!-- Nagłówek tygodnia -->
      <div class="week-label">Week {{ week.num }}</div>

      <!-- Karty Day -->
      <div class="week-row">
        <Day
          v-for="day in week.days"
          :key="day.name"
          :day="day"
          :dish-options="dishOptions"
          @update-slot="handleSlotUpdate"
        />
      </div>
  </div>
</template>

<script setup lang="ts">
import { WeekGet, DishGetShort } from '@/types/types'
import Day from '../components/Day.vue'

const props = withDefaults(defineProps<{
  week?: WeekGet
  dishOptions: Record<string, DishGetShort[]>
}>(), {
  week: () => ({
    num: 0,
    days: [],
    labels: [],
  })
});

const handleSlotUpdate = (payload: { dayName: string; slotIndex: number; newDishId: number }) => {
  const weekNum = props.week.num;

  // DayName → Index (1-based)
  const dayNameToIndex: Record<string, number> = {
    Monday: 1,
    Tuesday: 2,
    Wednesday: 3,
    Thursday: 4,
    Friday: 5,
    Saturday: 6,
  };

  const dayIndex = dayNameToIndex[payload.dayName];
  const globalSlotIndex = (weekNum - 1) * 30 + (dayIndex - 1) * 5 + payload.slotIndex;

  console.log('WEEK::received slot update', {
    weekNum,
    dayName: payload.dayName,
    slotIndex: payload.slotIndex,
    globalSlotIndex,
    newDishId: payload.newDishId,
  });

  // ewentualnie dalsza logika, np. emit do nadrzędnego komponentu
  // emit('update-slot-global', { globalSlotIndex, newDishId: payload.newDishId });
};



</script>

<style scoped>
.week-container {
  overflow: hidden;
}

.week-label {
  background-color: #333;
  color: white;
  font-size: 0.85rem;
  padding: 0.5rem;
  text-align: center;
  font-weight: 400;
}

.week-row {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
}

.days-row {
  display: flex;
  gap: 0;
  padding: 0;
  overflow-x: auto;
}
</style>
