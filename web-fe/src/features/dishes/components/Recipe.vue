<template>
  <div class="recipe-preparation-section">
    <div class="left-column">
      <div class="input-group">
        <label for="total-time">Total time</label>
        <input id="total-time" type="text" v-model="recipe.total_time"  @input="emit('update:hasPendingChanges', true)" />
      </div>

      <div class="input-group">
        <label for="before">Before</label>
        <textarea id="before" rows="2" v-model="recipe.before"  @input="emit('update:hasPendingChanges', true)"></textarea>
      </div>

      <div class="input-group">
        <label for="when-to-start">When to start</label>
        <textarea id="when-to-start" rows="2" v-model="recipe.when_to_start"  @input="emit('update:hasPendingChanges', true)"></textarea>
      </div>
    </div>

    <div class="right-column">
      <div class="input-group full-height">
        <label for="preparation">Preparation</label>
        <textarea id="preparation" v-model="recipe.preparation"  @input="emit('update:hasPendingChanges', true)"></textarea>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';
import { Recipe } from '@/types/types';
const props = defineProps<{
  recipe: Recipe;
  hasPendingChanges: boolean;
}>();

const emit = defineEmits(['update:hasPendingChanges']);

</script>

<style scoped>
/* Główny kontener, który ustawia layout dwukolumnowy */
.recipe-preparation-section {
  display: flex;
  gap: 24px; /* Odstęp między kolumnami */
  margin-top: 24px; /* Odstęp od elementów powyżej (np. przycisku Add) */
  width: 100%;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica,
    Arial, sans-serif;
  /* DODANE: Zapewnia, że kolumny rozciągają się do tej samej wysokości */
  align-items: stretch;
}

/* Stylizacja lewej kolumny */
.left-column {
  display: flex;
  flex-direction: column;
  gap: 16px; /* Odstępy między polami input w kolumnie */
  flex-basis: 35%; /* Szerokość lewej kolumny */
}

/* Stylizacja prawej kolumny */
.right-column {
  flex: 1; /* Prawa kolumna zajmuje resztę dostępnego miejsca */
}

/* Grupa (etykieta + input) */
.input-group {
  display: flex;
  flex-direction: column;
}

/* Klasa pomocnicza do rozciągnięcia pola na 100% wysokości */
.input-group.full-height {
  height: 100%;
}

.input-group.full-height textarea {
  height: 100%;
  min-height: 160px; /* Zwiększona minimalna wysokość dla lepszego dopasowania */
}

/* Style dla etykiet (np. "Total time") */
.input-group label {
  margin-bottom: 6px;
  font-size: 0.9rem;
  color: #6c757d; /* Szary kolor, pasujący do designu */
}

/* Wspólne style dla input i textarea */
.input-group input,
.input-group textarea {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #dcdfe6; /* Delikatna, szara ramka */
  border-radius: 4px; /* Lekko zaokrąglone rogi */
  font-size: 0.85rem;
  box-sizing: border-box; /* Gwarantuje, że padding i border nie powiększą elementu */
  transition: border-color 0.2s ease-in-out;
  background-color: #ffffff; /* Białe tło dla inputów */
  line-height: 1.5; /* Lepsza czytelność tekstu w wielu liniach */
}

/* DODANE: Wspólne style dla wszystkich pól textarea */
.input-group textarea {
  resize: vertical; /* Pozwala na zmianę wysokości przez użytkownika */
}


/* Efekt focus dla lepszego UX */
.input-group input:focus,
.input-group textarea:focus {
  outline: none;
  border-color: #c0c4cc;
}
</style>