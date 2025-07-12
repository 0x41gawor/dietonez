<template>
    <section>
        <div class="header">
            <SearchBar v-model="searchText" placeholder="Search..." />
            <div class="buttons">
                <RevertButton @click="handleRevertButtonClick" :disabled="!hasPendingChanges" />
                <UpdateButton @click="handleUpdateButtonClick" :disabled="!hasPendingChanges" />
            </div>
        </div>
        <DishesTable 
            :items="dishes"
            :current-page="1"
            :total-pages="totalPages"
            :page-size="pageSize"
            :page="page"
            :total="total"
            @item-updated="handleItemUpdate"
            @pageSizeChanged="handlePageSizeUpdate"
            @pageChanged="handlePageChange"
        />
    </section>  
</template>

<script setup lang="ts">
import './PW2X_DishesListView.style.css'
import { useDishesListViewLogic } from '../composables/useDishesListViewLogic'
import SearchBar from '@/components/SearchBar.vue';
import RevertButton from '@/components/RevertButton.vue';
import UpdateButton from '@/components/UpdateButton.vue';
import DishesTable from '../components/DishesTable.vue';
import { DishGetShort } from '@/types/types';   

const { meal } = defineProps<{ meal: 'Breakfast' | 'MainMeal' | 'Pre-Workout' | 'Supper' }>()

const {
    dishes,
    total,
    page,
    pageSize,
    totalPages,
    searchText,
    hasPendingChanges,
    handleItemUpdate,
    handleRevertButtonClick,
    handleUpdateButtonClick,
    handlePageSizeUpdate,
    handlePageChange    
} = useDishesListViewLogic(meal);
</script>