import {ref, computed, onMounted, Ref, watch} from 'vue'
import {useToast} from "vue-toastification";
import { useRouter } from 'vue-router'

import type { DietGet, DietPut, DishGetShort, WeekPut } from '@/types/types';
import {GetDishesParams} from '@/api/dishes';
import { updateDietById } from '@/api/diets'; // upewnij się, że masz to zaimportowane
import { getDietById } from '@/api/diets';
import { getDishes } from '@/api/dishes';

export function  useDietViewLogic(id: Ref<number>) {
    // ==== STATE ====
    const diet = ref<DietGet>({
            id: 0,
            name: '',
            descr: '',
            weeks: [],
            labels: [],
    });
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
        try {
            isLoading.value = true
            const response = await getDietById(id.value)
            diet.value = response;
            console.log(diet.value)
        } catch (error) {
            toast.error("Failed to get diet")
        } finally {
            isLoading.value = false
        }
    }

    async function fetchDishOptions() {
        const meals: GetDishesParams['meal'][] = ['Breakfast', 'MainMeal', 'Pre-Workout', 'Supper'];
        try {
            for (const meal of meals) {
                const dishes = await getDishes({ meal, min: true });
                dishOptions.value[meal] = dishes;
            }
        } catch (error) {
            console.error('Failed to fetch some dish options:', error);
            toast.error('Error loading some dish options');
        }
    }

    const handleSlotUpdate = (payload: { weekIndex: number, dayIndex: number, slotIndex: number; newDishId: number }) => {
        const weekIndex = payload.weekIndex;
        const dayIndex = payload.dayIndex;
        const slotIndexInDay = payload.slotIndex;
        console.log("Który slot dostanie update",
            "week:", weekIndex,
            "day:", dayIndex,
            "slot:", slotIndexInDay,
            "newDishId:", payload.newDishId
        );
        const slot = diet.value.weeks[weekIndex].days[dayIndex].slots[slotIndexInDay];

        if (!slot.dish) {
            slot.dish = { id: payload.newDishId, name: 'chuj', kcal: 0, protein: 0, carbs: 0, fat: 0 };
        } else {
            slot.dish.id = payload.newDishId;
        }
        hasPendingChanges.value = true;
        console.log("Diet new", diet.value)
    };

    const handleRevertButtonClick = () => {
        console.log("Revert button clicked")
        fetchDietGet();
        hasPendingChanges.value = false;
    }

        const handleUpdateButtonClick = async () => {
        console.log("Update button clicked");

        if (!diet.value) {
            toast.error("No diet to update");
            return;
        }

        try {
            const weeks: WeekPut[] = diet.value.weeks.map((week) => ({
            num: week.num,
            days: week.days.map((day) => ({
                name: day.name,
                slots: day.slots
                .filter(slot => slot.dish !== null)
                .map((slot) => ({
                    meal: slot.meal,
                    dish: { id: slot.dish!.id }
                })),
            })),
            }));

            const updatedDiet: DietPut = {
            id: diet.value.id,
            name: diet.value.name,
            descr: diet.value.descr,
            weeks,
            labels: diet.value.labels || [],
            };

            const response = await updateDietById(diet.value.id, updatedDiet);
            diet.value = response; // aktualizacja widoku po zapisie
            hasPendingChanges.value = false;
            toast.success("Diet updated successfully!");

        } catch (error) {
            toast.error("Failed to update diet");
            console.error("Update error:", error);
        }
        };


    return {
        diet,
        dishOptions,
        hasPendingChanges,
        handleSlotUpdate,
        handleRevertButtonClick,
        handleUpdateButtonClick,
    }
}