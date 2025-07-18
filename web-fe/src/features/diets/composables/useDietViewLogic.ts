import {ref, computed, onMounted, Ref, watch} from 'vue'
import {useToast} from "vue-toastification";
import { useRouter } from 'vue-router'

import type { DietGet } from '@/types/types';
import { getDietById } from '@/api/diets';

export function  useDietViewLogic(id: Ref<number>) {
    // ==== STATE ====
    const diet = ref<DietGet>(
        {
            id: 0,
            name: '',
            descr: '',
            weeks: [],
            labels: [],
        }
    );
    const hasPendingChanges = ref<boolean>(false)
    const isLoading = ref(true)
    // helpers
    const toast = useToast()

      // ==== L I F E C Y C L E ====
    watch(
    id,
    async (newId) => {
        if (newId > 0) {
        await fetchDietGet();
        }
    },
    { immediate: true }
    )

    // ==== A P I    C A L L S
    async function fetchDietGet() {
        console.log(id)
        try {
            isLoading.value = true
            const response = await getDietById(id.value)
            console.log("Fetched diet: ", response)
            diet.value = response;
        } catch (error) {
            toast.error("Failed to get diet")
        } finally {
            isLoading.value = false
        }
    }

    // ==== H A N D L E R S  ====
    const handleRevertButtonClick = () => {
        console.log("Revert button clicked")
        fetchDietGet();
    }
    const handleUpdateButtonClick = () => {
        console.log("Update button clicked")
    }

    return {
        diet,
        hasPendingChanges,
        handleRevertButtonClick,
        handleUpdateButtonClick,
    }
}