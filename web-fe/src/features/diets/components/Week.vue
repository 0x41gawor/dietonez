<template>
  <tr>
    <td class="col-label">Week {{ week.num }}</td>
    
  </tr>
</template>

<script setup lang="ts">
import { WeekGet } from '@/types/types';
import { ref, watch, toRefs } from 'vue'

const props = defineProps<{
  week: WeekGet
}>()
</script>

<style scoped>

</style>