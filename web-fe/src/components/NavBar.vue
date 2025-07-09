<template>
  <nav class="navbar">
    <div class="left">
      <RouterLink to="/home" class="back-link">
        <span class="icon">←</span>
        <span class="text">Home</span>
      </RouterLink>
      <slot>
        <span class="sep">›</span>
        <span>{{ currentLabel }}</span>
      </slot>
    </div>

    <ul class="nav-items">
      <li v-for="item in navItems" :key="item.path">
        <RouterLink :to="item.path" class="nav-link" active-class="active">
          {{ item.label }}
        </RouterLink>
      </li>
    </ul>
  </nav>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const navItems = [
  { label: 'Home', path: '/home' },
  { label: 'Ingredients', path: '/ingredients' },
  { label: 'Dishes', path: '/dishes' },
  { label: 'Diets', path: '/diets' },
];

const currentLabel = computed(() => {
  const current = navItems.find((item) => item.path === route.path);
  return current?.label ?? '';
});
</script>

<style scoped>
.navbar {
  display: flex;
  flex-direction: column;
  border-bottom: 1px solid #ddd;
  background-color: #f9f9f9;
  padding: 0.2rem 1rem;
}

.left {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.25rem;
  font-size: 0.85rem;
  color: #555;
}

.back-link {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  color: #333;
  text-decoration: none;
}

.back-link:hover {
  text-decoration: underline;
}

.icon {
  font-weight: bold;
  font-size: 1rem;
}

.nav-items {
  display: flex;
  justify-content: center;
  gap: 2rem;
  list-style: none;
  margin: 0;
  padding: 0.1rem 0;
}

.nav-link {
  color: var(--text-primary);
  font-weight: 500;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  transition: opacity 0.2s ease;
  text-decoration: none;
}

.nav-link:hover {
  opacity: 0.8;
}

.active {
  text-decoration: underline;
}

.sep {
  color: #aaa;
}
</style>
