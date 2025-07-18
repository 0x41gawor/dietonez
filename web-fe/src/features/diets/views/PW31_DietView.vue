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

            <textarea id="preparation" v-model="diet.descr" @input="hasPendingChanges = true"> </textarea>
            <div class="buttons">
                <RevertButton @click="handleRevertButtonClick" :disabled="!hasPendingChanges" /> 
                <UpdateButton @click="handleUpdateButtonClick" :disabled="!hasPendingChanges" />
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

const props = defineProps<{id: number}>()

const id = toRef(props, 'id')

const {
    diet,
    hasPendingChanges,
    handleRevertButtonClick,
    handleUpdateButtonClick,
} = useDietViewLogic(id);
</script>