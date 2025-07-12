<template>
  <div class="page-container">
    <div class="meal-types-grid">
      <MealCard variant="breakfast" @click="onClick('breakfast')">
        <template #icon>
          <img src="/icons/icons8-fry-100.png" alt="Breakfast icon" width="64" height="64" />
        </template>
        <template #label>Breakfasts</template>
      </MealCard>

      <MealCard variant="main-meal" @click="onClick('main-meal')">
        <template #icon>
         <img src="/icons/icons8-poultry-leg-100.png" alt="Breakfast icon" width="64" height="64" />
        </template>
        <template #label>Main Meals</template>
      </MealCard>

      <MealCard variant="pre-workout" @click="onClick('pre-workout')">
        <template #icon>
          <img src="/icons/icons8-banana-100.png" alt="Breakfast icon" width="64" height="64" />
        </template>
        <template #label>Pre-Workout</template>
      </MealCard>

      <MealCard variant="supper" @click="onClick('supper')">
        <template #icon>
          <img src="/icons/icons8-cheese-100.png" alt="Breakfast icon" width="64" height="64" />
        </template>
        <template #label>Supper</template>
      </MealCard>
    </div>
  </div>
</template>

<script setup lang="ts">
import MealCard from '../components/MealCard.vue'

function onClick(type: string) {
  console.log('Clicked on:', type)
  // tutaj możesz użyć np. router.push(`/meals/${type}`)
}
</script>

<style scoped>
.page-container {
  margin-top: 150px;
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center; /* <--- DODAJ TO! */
  padding: 2rem 1rem;
}

.meal-types-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 2rem;
  width: 100%;
  max-width: 818px; /* <= TYLE, ILE 2 kafle razem + gap */
  align-items: center; /* <--- DODAJ TO! */
}
</style>
