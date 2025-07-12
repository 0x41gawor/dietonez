import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';

import HomeView from '@/features/context/views/HomeView.vue';
import IngredientsView from '@/features/ingredients/views/IngredientsView.vue';
import DishesView from '@/features/dishes/views/PW2_DishesView.vue';
import DietsView from '@/features/diets/views/DietsView.vue';

const routes: RouteRecordRaw[] = [
  { path: '/', redirect: '/home' },
  { path: '/home', component: HomeView },
  { path: '/ingredients', component: IngredientsView },
  { path: '/dishes', component: DishesView },
  { path: '/diets', component: DietsView },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;