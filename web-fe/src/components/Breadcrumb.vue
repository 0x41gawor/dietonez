<template>
  <nav class="breadcrumb">
    <span
      v-for="(item, index) in items"
      :key="index"
      class="crumb"
    >
      <span v-if="index > 0">›</span>
      {{ item }}
    </span>
  </nav>
</template>

<script setup lang="ts">
defineProps<{ items: string[] }>();
</script>

<style scoped>
.breadcrumb {
  color: var(--text-muted);
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.crumb {
  margin-right: 0.3rem;
}
</style>