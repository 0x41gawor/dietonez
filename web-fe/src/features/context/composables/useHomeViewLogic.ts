import { getDietContext } from "@/api/diets";
import { DietContextGet, DietContextPut } from "@/types/types"
import { onMounted, ref } from 'vue';
import {useToast} from "vue-toastification";



export function useHomeViewLogic() {

    const dietContext = ref<DietContextGet>({
        activeDiet: {id: 0, name: ""},
        currentWeek: 0,
        currentDay: 1,
        startDate: new Date('2025-01-01'),
        weight: 82
    })
    const hasPendingChanges = ref<boolean>(false)

    // helpers
    const toast = useToast()

    async function fetchDietContext() {
        try {
            const response = await getDietContext();
            dietContext.value = response;
            console.log(dietContext.value)
        } catch (error) {
            toast.error("Failed to fetch dietContext");
        } finally {

        }
    }

    onMounted(fetchDietContext);

    const handleRevertButtonClick = () => {
        console.log("Revert button clicked")
        fetchDietContext();
        hasPendingChanges.value = false;
    }

     const handleUpdateButtonClick = async () => {
        console.log("Update button clicked");
     }

    return {
        dietContext,
        hasPendingChanges,
        handleRevertButtonClick,
        handleUpdateButtonClick,
    }
}