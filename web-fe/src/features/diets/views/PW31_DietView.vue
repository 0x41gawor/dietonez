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

            <textarea id="descr" v-model="diet.descr" @input="hasPendingChanges = true"> </textarea>
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

    </section>
</template>


<script setup lang="ts">
import './PW31_DietView.style.css'
import { useDietViewLogic } from '../composables/useDietViewLogic';
import { toRef } from 'vue';
import RevertButton from '@/components/RevertButton.vue';
import UpdateButton from '@/components/UpdateButton.vue';
import WeeksTable from '../components/WeeksTable.vue';

const props = defineProps<{id: number}>()

const id = toRef(props, 'id')

const {
    diet,
    dishOptions,
    hasPendingChanges,
    handleSlotUpdate,
    handleRevertButtonClick,
    handleUpdateButtonClick,
} = useDietViewLogic(id);
</script>