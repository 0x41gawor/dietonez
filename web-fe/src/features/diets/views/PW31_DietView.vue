<template>
    <section>
        <div class = "header">
            <input
                v-if="diet"
                v-model="diet.name"
                @input="hasPendingChanges = true"
                :class="['diet-title-input']"
                placeholder="Diet name"
            />

            <textarea id="descr" v-model="diet.descr" @input="hasPendingChanges = true"/>
            <div class="buttons">
                <RevertButton @click="handleRevertButtonClick" :disabled="!hasPendingChanges" /> 
                <UpdateButton @click="handleUpdateButtonClick" :disabled="!hasPendingChanges" />
            </div>
        </div>

        <WeeksTable
        :items="diet?.weeks || []"
        :dishOptions="dishOptions"
        @update-slot="handleSlotUpdate"
        </WeeksTable>            

        
        <div class="delete-button-wrapper">
            <div class="left-buttons">
                <AddWeekButton @click="handleAddWeekButtonClick" :disabled="false" />
                <DeleteWeekButton @click="handleDeleteWeekButtonClick" :disabled="false" />
            </div>

            <div class="right-buttons">
                <DeleteButton @click="handleDeleteButtonClick" :disabled="false" />
            </div>
        </div>

    </section>
</template>


<script setup lang="ts">
import './PW31_DietView.style.css'
import { useDietViewLogic } from '../composables/useDietViewLogic';
import { toRef } from 'vue';
import RevertButton from '@/components/RevertButton.vue';
import UpdateButton from '@/components/UpdateButton.vue';
import DeleteButton from '@/components/DeleteButton.vue';
import WeeksTable from '../components/WeeksTable.vue';
import AddWeekButton from '../components/AddWeekButton.vue';
import DeleteWeekButton from '../components/DeleteWeekButton.vue';

const props = defineProps<{id: number}>()

const id = toRef(props, 'id')

const {
    diet,
    dishOptions,
    hasPendingChanges,
    handleSlotUpdate,
    handleRevertButtonClick,
    handleUpdateButtonClick,
    handleDeleteButtonClick,
    handleAddWeekButtonClick,
    handleDeleteWeekButtonClick,
} = useDietViewLogic(id);
</script>