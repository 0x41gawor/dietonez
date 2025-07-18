<template>
  <div class="table-container">
    <div class="table-wrapper">
      <table class="week-table">
        <thead>
          <tr>
            <th v-for="day in days" :key="day" class="col-day">
              {{ day }}
            </th>
          </tr>
        </thead>
        <tbody>
          <!-- <Week
            v-for="(week, index) in weeks"
            :key="index"
            :week-data="week"
            :week-index="index + 1"
            :meal-options="mealOptions"
            @update="handleWeekUpdate"
          /> -->
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { WeekGet } from '@/types/types';

const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
// const weeks = [] // tutaj w przyszłości wejdzie realna lista tygodni
// const mealOptions = [] // select posiłków (np. name + id)

// const handleWeekUpdate = (payload) => {
//   console.log('Updated week:', payload)
// }
const props = defineProps<{
    items: WeekGet[]
}>();

</script>

<style scoped>
.table-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #fff;
  display: flex;
  flex-direction: column;
  height: 760px;
}

.table-wrapper {
  flex: 1;
  overflow: auto;
}

.week-table {
  width: 100%;
  border-collapse: collapse;
}

.week-table th,
.week-table td {
  padding: 10px;
  text-align: center;
  border-bottom: 1px solid #ddd;
  vertical-align: middle;
}

.week-table th {
  font-weight: 200;
  font-size: 0.75rem;
  color: #0e162a; 
  text-transform: uppercase;
  background-color: #fafafa;
}

.col-day {
  min-width: 120px;
}

</style>