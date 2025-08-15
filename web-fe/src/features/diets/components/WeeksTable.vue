<template>
  <div class="weeks-table">
    <!-- Header dni tygodnia -->
    <div class="table-header">
      <div
        v-for="day in days"
        :key="day"
        class="col-day"
      >
        {{ day }}
      </div>
    </div>

    <!-- Tygodnie -->
    <div
      v-for="week in items"
      :key="week.num"
    >
      <Week
        :week="week"
        :dishOptions="dishOptions"
        @update-slot="handleSlotUpdate"
        @update-goal="handleGoalUpdate"
      />
    </div>
  </div>
</template>


<script setup lang="ts">
import { WeekGet, DishGetShort } from '@/types/types'
import Week from './Week.vue';

const props = defineProps<{
  items: WeekGet[]
  dishOptions: Record<string, DishGetShort[]>
}>()

// --- EMITY ZDARZEŃ ---
const emit = defineEmits<{
  (e: 'update-slot', payload: { weekIndex: number, dayIndex: number, slotIndex: number; newDishId: number }): void;
  (e: 'update-goal', payload: { weekIndex: number; dayIndex: number; newGoal: number }): void;
}>();

const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

const handleSlotUpdate = (payload: { weekIndex: number, dayIndex: number, slotIndex: number; newDishId: number }) => {
  emit('update-slot', {weekIndex: payload.weekIndex, dayIndex: payload.dayIndex, slotIndex: payload.slotIndex, newDishId: payload.newDishId})
};

const handleGoalUpdate = (payload: { weekIndex: number; dayIndex: number; newGoal: number }) => {
  emit('update-goal', { weekIndex: payload.weekIndex, dayIndex: payload.dayIndex, newGoal: payload.newGoal });
};

</script>

<style scoped>
.weeks-table {
  width: 100%;
  max-width: 1200px;     /* lub inna szerokość, np. 1000px */
  margin: 0 auto;         /* wyśrodkowanie */
  box-sizing: border-box;
  border: 1px solid #bbbbbb;
  border-radius: 6px 6px 6px 6px;
  flex: 1;
  overflow: auto;
  height: 765px;
}

.table-header {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  font-weight: bold;
  font-size: 0.75rem;
  text-transform: uppercase;
  text-align: center;
  background-color: #fafafa;
  padding: 0.3rem 0;
  border-bottom: 1px solid #ccc;
  border-radius: 6px;
}

.weeks-table::-webkit-scrollbar {
  width: 10px;              /* szerokość paska pionowego */
  height: 10px;             /* wysokość paska poziomego (jeśli jest) */
}

.weeks-table::-webkit-scrollbar-track {
  background: #f0f0f0;
  border-radius: 8px;       /* zaokrąglenie toru */
}

.weeks-table::-webkit-scrollbar-thumb {
  background-color: #bbb;
  border-radius: 8px;       /* zaokrąglenie uchwytu */
  border: 2px solid #f0f0f0; /* padding wokół thumb-a */
}

.weeks-table::-webkit-scrollbar-thumb:hover {
  background-color: #999;
}
</style>
