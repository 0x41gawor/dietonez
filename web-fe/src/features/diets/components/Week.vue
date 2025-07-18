<template>
  <tr>
    <td class="col-label">Week {{ num }}</td>
    <!-- <td v-for="(meal, dayIndex) in weekData" :key="dayIndex">
      <select
        v-model="localWeekData[dayIndex]"
        class="meal-select"
        :class="'meal--' + getMealType(localWeekData[dayIndex])"
        @change="emitUpdate"
      >
        <option
          v-for="option in mealOptions"
          :key="option.id"
          :value="option.id"
        >
          {{ option.name }}
        </option>
      </select>
    </td> -->
  </tr>
</template>

<script setup lang="ts">
import { ref, watch, toRefs } from 'vue'

const props = defineProps<{
  num: number 
}>()
</script>

<style scoped>

</style>