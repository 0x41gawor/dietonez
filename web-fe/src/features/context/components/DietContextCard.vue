<template>
  <div class="table-container">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th class="col-name">Active Diet</th>
            <th class="col-numeric">Week</th>
            <th class="col-numeric">Day</th>
            <th class="col-numeric">Start Date</th>
            <th class="col-numeric">Weight [kg]</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              <select
                :value="context.activeDiet.id"
                @change="handleDietChange"
                class="diet-select"
              >
                <option
                  v-for="option in dietOptions"
                  :key="option.id"
                  :value="option.id"
                >
                  {{ option.name }}
                </option>
              </select>
            </td>
            <td>{{ context.currentWeek }}</td>
            <td>{{ weekday }}</td>
            <td>{{ formatDate(context.startDate) }}</td>
            <td>{{ context.weight.toFixed(1) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { DietContextGet, DietMin } from '@/types/types'
import { computed } from 'vue'

const props = defineProps<{
  context: DietContextGet
  dietOptions: DietMin[]
}>()

const emit = defineEmits<{
  (e: 'update-context', newDietId: number): void
}>()

function handleDietChange(event: Event) {
  const selectedId = Number((event.target as HTMLSelectElement).value)
  const newDietId = selectedId;
  console.log("newID", newDietId);
  emit('update-context', newDietId);
}

const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
const weekday = computed(() => days[props.context.currentDay - 1])

function formatDate(date: Date): string {
  const d = new Date(date)
  return isNaN(d.getTime()) ? '' : d.toISOString().slice(0, 10)
}
</script>



<style scoped>
.table-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  background-color: #ffffff;
  display: flex;
  flex-direction: column;
}

.table-wrapper {
  flex: 1;
  overflow: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  min-width: 600px;
}

th {
  padding: 8px 10px;
  text-align: left;
  font-weight: 100;
  color: #666;
  font-size: 0.875rem;
  border-bottom: 1px solid #e0e0e0;
  white-space: nowrap;
  background-color: #f9f9f9;
}

td {
  padding: 2px 10px;
  border-bottom: 1px solid #e0e0e0;
  color: #333;
  font-size: 1rem;
  vertical-align: middle;
  border: 1px solid green;
}

.col-name {
  width: 55%;
  border: 1px solid red;
}

.col-numeric {
  width: 10%;
  text-align: center;
}

.diet-select {
  font-weight: 100;
  border: none;
  background-color: transparent;
  cursor: pointer;
  width: 100%;
  border-radius: 2px;
  padding: 0;
  appearance: none; /* najważniejsze */
  -webkit-appearance: none; /* Safari/Chrome */
  -moz-appearance: none; /* Firefox */
  background-image: none; /* dla pewności */
}
</style>