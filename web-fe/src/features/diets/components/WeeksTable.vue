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

const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
</script>

<style scoped>
.weeks-table {
  width: 100%;
  max-width: 1200px;     /* lub inna szerokość, np. 1000px */
  margin: 0 auto;         /* wyśrodkowanie */
  box-sizing: border-box;
  border: 1px solid #bbbbbb;
  border-radius: 6px 6px 0px 0px;
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
</style>
