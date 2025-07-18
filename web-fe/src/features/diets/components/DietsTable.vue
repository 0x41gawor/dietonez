<template>
  <div class="table-container">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th class="col-name header-diet">Name</th>
            <th class="col-description header-diet">Description</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="!items || items.length === 0">
            <td colspan="2" class="empty-state">No diets to display.</td>
          </tr>
          <tr v-for="item in items" :key="item.id" @click="goToEdit(item.id)" class="clickable-row">
            <td>
              <input
                v-model="item.name"
                type="text"
                @click.stop
                class="edit-input"
                @change="handleCellEdition(item)"
              />
            </td>
            <td>
              <input
                v-model="item.descr"
                type="text"
                @click.stop
                class="edit-input"
                @change="handleCellEdition(item)"
              />
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="table-footer"></div>
  </div>
</template>

<script setup lang="ts">
import type { DietShort } from '@/types/types'
import { ref, watch, PropType } from 'vue'
import { useRouter } from 'vue-router'
const router = useRouter()

const props = defineProps({
  items: { type: Array as PropType<DietShort[]>, required: true }
})

const emit = defineEmits(['itemUpdated'])

const items = ref<DietShort[]>([])

watch(() => props.items, (newVal) => {
  items.value = JSON.parse(JSON.stringify(newVal))
}, { immediate: true, deep: true })

const goToEdit = (id: number) => {
  router.push(`/diets/${id}`)
}

const handleCellEdition = (updatedItem: DietShort) => {
  emit('itemUpdated', updatedItem)
}

defineExpose({ getUpdatedItems: () => items.value })
</script>

<style scoped>
.table-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  background-color: #ffffff;
  display: flex;
  flex-direction: column;
  height: 760px;
}
.table-wrapper {
  flex: 1;
  overflow: auto;
}
table {
  width: 100%;
  border-collapse: collapse;
  min-width: 600px;
}
th {
  padding: 8px 10px;
  text-align: left;
  font-weight: 100;
  color: #666;
  font-size: 0.875rem;
  white-space: nowrap;
  position: sticky;
  top: 0;
  z-index: 1;
}
.col-name {
  width: 40%;
}
.col-description {
  width: 60%;
}
tbody tr:hover {
  background-color: #f5f5f5;
}
td {
  padding: 12px 14px;
  border-bottom: 1px solid #e0e0e0;
  color: #333;
  font-size: 0.95rem;
  vertical-align: middle;
}
.edit-input {
  width: 100%;
  padding: 0;
  margin: 0;
  background-color: transparent;
  border: none;
  outline: none;
  font-family: inherit;
  font-size: inherit;
  color: inherit;
}
.edit-input:focus {
  background-color: #ffffff;
  outline: 2px solid #818cf8;
  outline-offset: -1px;
  border-radius: 0px;
}
.table-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 16px;
  border-top: 1px solid #e0e0e0;
  font-size: 0.8rem;
  color: #666;
  flex-shrink: 0;
  height: 20px;
}
.clickable-row {
  cursor: pointer;
}
.header-diet {
  background-color: var(--color-grey-100);
}
</style>