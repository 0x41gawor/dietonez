import { getDietContext, getDietMins, updateDietContext } from "@/api/context";
import { updateDietById } from "@/api/diets";
import { DietContextGet, DietContextPut, DietMin } from "@/types/types"
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
    const dietOptions = ref<DietMin[]>([]);
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

    async function fetchDietOptions() {
        try {
            const response = await getDietMins();
            console.log(response)
            dietOptions.value = response;
        } catch (error) {
            toast.error("Failed to fetch diet options");
        }

    }

    onMounted(async () => {
    await fetchDietContext()
    await fetchDietOptions()
    })

    const handleActiveDietChange = (newDietId: number) => {
        dietContext.value.activeDiet.id = newDietId
        hasPendingChanges.value = true
    }

    const handleWeightChange = (newWeight: number) => {
        dietContext.value.weight = newWeight
        hasPendingChanges.value = true
    }

    const handleStartDateChange = (newDate: Date) => {
        dietContext.value.startDate = newDate
        hasPendingChanges.value = true
    }

    const handleRevertButtonClick = () => {
        fetchDietContext();
        hasPendingChanges.value = false;
    }

     const handleUpdateButtonClick = async () => {
        try {
            const updatedDietContext: DietContextPut = {
                activeDiet: {id: dietContext.value.activeDiet.id, name: ""},
                startDate: dietContext.value.startDate,
                weight: dietContext.value.weight,
            }
            const response = await updateDietContext(updatedDietContext);
            dietContext.value = response;
            hasPendingChanges.value = false;
            toast.success("Diet Context updated :)")
        } catch (error: any) {
            toast.error("Failed to update dietContext")

            if (error.response && error.response.data) {
                toast.error(`Update error: ${error.response.data}`)
            } else {
                toast.error(`Unexpected error: ${error.message || error}`)
            }
        }

     }

    return {
        dietContext,
        dietOptions,
        hasPendingChanges,
        handleActiveDietChange,
        handleWeightChange,
        handleStartDateChange,
        handleRevertButtonClick,
        handleUpdateButtonClick,
    }
}