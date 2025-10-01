<template>
  <div class="week-container">
     <!-- Nagłówek tygodnia -->
      <div class="week-label">Week {{ week.num }}</div>
      <div class="week-stats-label">Avg Kcal: <strong> {{ week?.summary?.avgKcal }}</strong> Avg Prot: <strong>{{ week?.summary?.avgProt }}</strong> [g/kg] Avg Fat:<strong> {{ week?.summary?.avgFat }} [%] </strong> </div>

      <!-- Karty Day -->
      <div class="week-row">
        <Day
          v-for="day in week.days"
          :key="day.name"
          :day="day"
          :dish-options="dishOptions"
          @update-slot="handleSlotUpdate"
          @update-goal="handleGoalUpdate"
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
    summary: {avgKcal: 0, avgFat: 0, avgProt: 0},
    labels: [],
  })
});

// --- EMITY ZDARZEŃ ---
const emit = defineEmits<{
  (e: 'update-slot', payload: { weekIndex: number, dayIndex: number, slotIndex: number; newDishId: number }): void;
  (e: 'update-goal', payload: { weekIndex: number; dayIndex: number; newGoal: number }): void;
}>();


const handleSlotUpdate = (payload: { dayIndex: number; slotIndex: number; newDishId: number }) => {
  const weekIndex  = props.week.num -1;
  emit('update-slot', { weekIndex: weekIndex, dayIndex: payload.dayIndex, slotIndex: payload.slotIndex, newDishId: payload.newDishId})
};

const handleGoalUpdate = (payload: { dayIndex: number; newGoal: number }) => {
  const weekIndex = props.week.num - 1;
  emit('update-goal', { weekIndex, dayIndex: payload.dayIndex, newGoal: payload.newGoal });
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

.week-stats-label {
  background-color: #333;
  color: #888;
  font-size: 0.7rem;
  padding: 0.2rem;
  text-align: center;
  font-weight: 400;
}

.week-row {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
}

.days-row {
  display: flex;
  gap: 0;
  padding: 0;
  overflow-x: auto;
}
</style>
