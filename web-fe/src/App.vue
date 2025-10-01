<template>
  <div id="app" :class="$route.name">
    <NavBar />
    <main class="main-content">
      <RouterView />
    </main>
  </div>
</template>


<script setup lang="ts">
import NavBar from './components/NavBar.vue';
</script>

<style>
.main-content {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.DietView .main-content {
  max-width: 1500px;
}
</style>