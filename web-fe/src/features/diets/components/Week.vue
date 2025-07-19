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

</script>

<style scoped>
.week-container {
  border: 1px solid #0f0;
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
