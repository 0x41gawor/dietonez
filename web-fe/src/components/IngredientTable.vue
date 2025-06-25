<template>
  <div>
    <h2>Ingredients</h2>
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Default Amount</th>
          <th>Unit</th>
          <th>Shop Style</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(ingredient, index) in ingredients" :key="index">
          <td>{{ ingredient.id ?? 'new' }}</td>
          <td>
            <input v-model="ingredient.name" :disabled="ingredient.id !== null" />
          </td>
          <td>
            <input v-model="ingredient.defaultAmount" type="number" :disabled="ingredient.id !== null" />
          </td>
         <td>
            <select v-model="ingredient.unit" :disabled="ingredient.id !== null">
                <option v-for="unit in units" :key="unit.id" :value="unit.name">
                {{ unit.name }}
                </option>
            </select>
          </td>
          <td>
            <input v-model="ingredient.shopStyle" :disabled="ingredient.id !== null" />
          </td>
        </tr>
      </tbody>
    </table>

    <button @click="addRow" class="add-btn">➕ Dodaj nowy wiersz</button>
    <button @click="bulkCreate" class="bulk-btn">📤 Bulk Create</button>
  </div>
</template>

<script>
import axios from 'axios'
import { onMounted, ref } from 'vue'

export default {
  name: "IngredientTable",
  setup() {
    const ingredients = ref([])
    const units = ref([])

    const fetchUnits = async () => {
    try {
        const res = await axios.get('http://192.46.236.119:8080/api/v1/ingredient-units')
        units.value = res.data
    } catch (err) {
        console.error("Failed to fetch units:", err)
    }
    }


    const fetchIngredients = async () => {
      try {
        const res = await axios.get('http://192.46.236.119:8080/api/v1/ingredients')
        ingredients.value = res.data
      } catch (err) {
        console.error("Failed to fetch ingredients:", err)
      }
    }

    const addRow = () => {
      ingredients.value.push({
        id: null,
        name: '',
        default_amount: '',
        unit: '',
        shop_style: ''
      })
    }

    const bulkCreate = async () => {
      const toSend = ingredients.value.filter(i => i.id === null)
      try {
        await axios.post('http://192.46.236.119:8080/api/v1/ingredients/bulk', toSend)
        await fetchIngredients()
      } catch (err) {
        console.error("Bulk create failed:", err)
      }
    }

    onMounted(() => {
        fetchIngredients()
        fetchUnits()
    })


    return {
      ingredients,
      addRow,
      bulkCreate,
      units
    }
  }
}
</script>

<style scoped>
table {
  border-collapse: collapse;
  width: 100%;
}
th, td {
  padding: 8px;
  border: 1px solid #ddd;
}
input {
  width: 100%;
  padding: 4px;
  box-sizing: border-box;
}
.add-btn {
  margin-top: 1rem;
  padding: 10px;
  width: 100%;
  font-size: 1.2rem;
}
.bulk-btn {
  margin-top: 0.5rem;
  padding: 8px;
  width: 100%;
  font-size: 1rem;
}
</style>
\