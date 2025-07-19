import {ref, computed, onMounted, Ref, watch} from 'vue'
import {useToast} from "vue-toastification";
import { useRouter } from 'vue-router'

import type { DietGet, DishGetShort } from '@/types/types';
import {GetDishesParams} from '@/api/dishes';
import { getDietById } from '@/api/diets';
import { getDishes } from '@/api/dishes';

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
    const dishOptions = ref<Record<string, DishGetShort[]>>({});
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

    onMounted(fetchDishOptions);

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

    async function fetchDishOptions() {
        console.log('ELO')
        const meals: GetDishesParams['meal'][] = ['Breakfast', 'MainMeal', 'Pre-Workout', 'Supper'];
        try {
            for (const meal of meals) {
                const dishes = await getDishes({ meal, min: true });
                console.log(dishes);
                dishOptions.value[meal] = dishes;
            }
        } catch (error) {
            console.error('Failed to fetch some dish options:', error);
            toast.error('Error loading some dish options');
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
        dishOptions,
        hasPendingChanges,
        handleRevertButtonClick,
        handleUpdateButtonClick,
    }
}