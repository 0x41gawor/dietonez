import { DietShort } from "@/types/types";
import { onMounted, ref } from "vue";
import { computed } from "vue";
import { useToast } from "vue-toastification";
import { updateDietShort, getAllDiets } from '@/api/diets'


export function useDietsListViewLogic() {
    // ==== S T A T E ====
    const diets = ref<DietShort[]>([]);
    const pendingChanges = ref<Record<number, DietShort>>({});
    const searchText = ref<string>('');
    const hasPendingChanges = computed( () => Object.keys(pendingChanges.value).length > 0 );
    // helpers
    const toast = useToast();

    // ==== M E T H O D S ====
    // ==== A P I   C A L L S ====

    const fetchDiets = async () => {
        try {
            diets.value = await getAllDiets();
        } catch (error) {
            console.error('Failed to fetch diets:', error);
        }
    };

    
    // ==== L I F E C Y C L E ====
    onMounted(() => {
        fetchDiets();
    });
    // ==== H A N D L E R S ====
    const handleItemUpdate = (item: DietShort) => {
        console.log('Item updated:', item);
        const index = diets.value.findIndex(d => d.id === item.id);
        if (index !== -1) {
            diets.value[index] = item;
            pendingChanges.value[item.id] = item;
        }
    }
    const handleRevertButtonClick = () => {
        pendingChanges.value = {};
        toast.info('Changes reverted');
        fetchDiets();
    }
    const handleUpdateButtonClick = async () => {
        console.log('Update button clicked');

        const updates = Object.values(pendingChanges.value);

        if (updates.length === 0) {
            toast.info('No changes to update');
            return;
        }

        try {
            await Promise.all(updates.map(diet => updateDietShort(diet.id, diet)));

            toast.success('Changes saved');
            pendingChanges.value = {};
            await fetchDiets();
        } catch (err) {
            console.error('Failed to update diets:', err);
            toast.error('Update failed');
        }
    };
    const handleAddButtonClick = () => {
        console.log('Add button clicked');
    }
    // ==== R E T U R N ====
    return {
        diets,
        searchText,
        pendingChanges,
        hasPendingChanges,
        handleItemUpdate,
        handleRevertButtonClick,
        handleUpdateButtonClick,
        handleAddButtonClick
    };
}