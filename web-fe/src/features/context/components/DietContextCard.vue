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
            <td class="col-numeric">{{ context.currentWeek }}</td>
            <td class="col-numeric">{{ weekday }}</td>
            <td>
            <input
              type="date"
              :value="formatDateForInput(context.startDate)"
              @change="handleDateChange"
              class="diet-input"
            />
          </td>
          <td>
            <input
              type="number"
              step="0.1"
              min="0"
              :value="context.weight"
              @input="handleWeightChange"
              class="diet-input"
            />
          </td>
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
  (e: 'update-weight', newWeight: number): void
  (e: 'update-start-date', newDate: Date): void
}>()

function handleDietChange(event: Event) {
  const selectedId = Number((event.target as HTMLSelectElement).value)
  emit('update-context', selectedId)
}

function handleWeightChange(event: Event) {
  const newWeight = Number((event.target as HTMLInputElement).value)
  emit('update-weight', newWeight)
}

function handleDateChange(event: Event) {
  const newDate = new Date((event.target as HTMLInputElement).value)
  emit('update-start-date', newDate)
}

function formatDateForInput(date: Date): string {
  return new Date(date).toISOString().slice(0, 10)
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
}

.col-name {
  width: 55%;
}

.col-numeric {
  width: 10%;
  text-align: center;
}

td.col-numeric {
  text-align: center;
  vertical-align: middle;
  padding: 6px 0;
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

.diet-input {
  width: 100%;
  height: 34px;
  padding: 0;
  border: none;
  border-radius: 2px;
  background-color: transparent;
  font-size: 0.95rem;
  font-family: inherit;
  text-align: center;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: textfield; /* dla number w FF */
  box-sizing: border-box;
}

.diet-input:focus {
  outline: none;
  background-color: #f0f0f0;
}

/* Styl ikonki kalendarza */
input[type="date"].diet-input::-webkit-calendar-picker-indicator {
  filter: grayscale(100%);
  cursor: pointer;
  margin-right: 6px;
}
</style>