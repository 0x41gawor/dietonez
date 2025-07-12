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
            :meal="meal"
            @item-updated="handleItemUpdate"
            @pageSizeChanged="handlePageSizeUpdate"
            @pageChanged="handlePageChange"
        />
        <div class="header">
                <AddButton id="add-dish-button" @click="handleAddButtonClick" :disabled=false />
        </div>
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
import AddButton from '@/components/AddButton.vue';

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
    handlePageChange,
    handleAddButtonClick,
} = useDishesListViewLogic(meal);
</script>