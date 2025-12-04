
<template>
  <div class="main-container">
  <h1>Queries Integria</h1>

  <div class="container-query">
   <textarea
      v-model="query"
      placeholder="Escribe tu consulta aquí..."
      rows="3"
      @keydown.enter.prevent="setQuery"
    ></textarea>
    <div class="button-group">
      <button @click="setQuery" class="btn-search">Search</button>
      <button @click="resetQuery" class="btn-reset">Reset</button>
    </div>
  </div>

  <!-- Mostrar cuando se ha hecho una búsqueda -->
  <div v-if="hasSearched" class="results">
    <h2>Resultados:</h2>

    <!-- Sin resultados -->
    <div v-if="resultData.length === 0" class="card card-empty">
      <div class="card-label">Sin resultados</div>
      <div class="card-message">No se encontraron datos para esta consulta</div>

      <!-- Mostrar SQL solo cuando hay problemas (sin resultados) -->
      <div v-if="sqlQuery" class="sql-display-error">
        <div class="sql-header">
          <strong>SQL ejecutado:</strong>
          <button @click="copySQL" class="btn-copy-sql" title="Copiar SQL">📋</button>
        </div>
        <code>{{ sqlQuery }}</code>
      </div>
    </div>

    <!-- Card para valores únicos/cantidades -->
    <div v-else-if="isSingleValue" class="card">
      <div class="card-label">{{ getFirstKey }}</div>
      <div class="card-value">{{ formatValue(getFirstValue) }}</div>
    </div>

    <!-- Tabla para múltiples campos -->
    <div v-else class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th v-for="key in getColumns" :key="key">{{ key }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(row, index) in resultData" :key="index">
            <td v-for="key in getColumns" :key="key">{{ formatValue(row[key]) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { setPost } from './api/api_base'

const query = ref<string>('')
const resultData = ref<any[]>([])
const hasSearched = ref<boolean>(false)
const sqlQuery = ref<string>('')

const setQuery = async () => {
  if (!query.value.trim()) return

  const response = await setPost(query.value)
  console.log('response', response)

  hasSearched.value = true

  // Acceder solo a los datos
  if (response && response.success && response.data) {
    resultData.value = response.data
    sqlQuery.value = response.sql || ''
    console.log('Solo datos:', response.data)
    console.log('SQL generado:', response.sql)
    console.log('Columnas detectadas:', response.data.length > 0 ? Object.keys(response.data[0]) : [])
  } else {
    resultData.value = []
    sqlQuery.value = response?.sql || ''
  }
}

const resetQuery = () => {
  query.value = ''
  resultData.value = []
  hasSearched.value = false
  sqlQuery.value = ''
}

const copySQL = async () => {
  try {
    await navigator.clipboard.writeText(sqlQuery.value)
    console.log('SQL copiado al portapapeles')
  } catch (err) {
    console.error('Error al copiar SQL:', err)
  }
}

// Formatear valores para mostrar
const formatValue = (value: any): string => {
  if (value === null || value === undefined) return '-'

  // Detectar y formatear fechas ISO
  if (typeof value === 'string' && /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/.test(value)) {
    const date = new Date(value)
    return date.toLocaleDateString('es-ES', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    })
  }

  // Decodificar entidades HTML
  if (typeof value === 'string' && value.includes('&#x')) {
    const textarea = document.createElement('textarea')
    textarea.innerHTML = value
    return textarea.value
  }

  return String(value)
}

// Detectar si es un valor único (1 fila con 1 o 2 campos)
const isSingleValue = computed(() => {
  if (resultData.value.length !== 1) return false
  const keys = Object.keys(resultData.value[0])
  return keys.length <= 2
})

// Obtener columnas de la tabla
const getColumns = computed(() => {
  if (resultData.value.length === 0) return []
  const keys = Object.keys(resultData.value[0])
  console.log('Keys obtenidas para columnas:', keys)
  return keys
})

// Obtener primera clave para la card
const getFirstKey = computed(() => {
  if (resultData.value.length === 0) return ''
  const keys = Object.keys(resultData.value[0])
  return keys[0]
})

// Obtener primer valor para la card
const getFirstValue = computed(() => {
  if (resultData.value.length === 0) return ''
  const keys = Object.keys(resultData.value[0])
  const firstKey = keys[0]
  return firstKey ? resultData.value[0][firstKey] : ''
})

</script>

<style scoped>

.main-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  min-height: 100vh;
  padding-top: 2rem;
}

h1 {
  text-align: center;
  margin-bottom: 1rem;
}

.container-query {
  padding: 2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 25px;
  width: 100%;
}

.container-query > textarea {
  padding: 20px;
  font-size: 18px;
  width: 800px;
  max-width: 80vw;
  border-radius: 10px;
  resize: vertical;
  font-family: inherit;
  line-height: 1.5;
  background: #2a2a2a;
  border: 2px solid #3a3a3a;
  color: rgba(255, 255, 255, 0.87);
  transition: border-color 0.3s ease;
}

.container-query > textarea:focus {
  outline: none;
  border-color: #667eea;
}

.container-query > textarea::placeholder {
  color: rgba(255, 255, 255, 0.4);
}

.button-group {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.button-group button {
  height: 55px;
  width: 150px;
  padding: 0;
  border-radius: 10px;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
  color: white;
  border: none;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.btn-search {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
}

.btn-search:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
}

.btn-search:active {
  transform: translateY(0);
}

.btn-reset {
  background: linear-gradient(135deg, #4a4a4a 0%, #2a2a2a 100%);
  border: 2px solid #5a5a5a;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
}

.btn-reset:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.5);
  border-color: #667eea;
}

.btn-reset:active {
  transform: translateY(0);
}

.results {
  width: 100%;
  padding: 0 2rem;
  margin-top: 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.results h2 {
  text-align: center;
  margin-bottom: 1.5rem;
  width: 100%;
}

/* Mostrar SQL cuando hay error (sin resultados) */
.sql-display-error {
  margin-top: 1rem;
  padding: 1rem;
  background: #1a1a1a;
  border: 1px solid #667eea;
  border-radius: 8px;
  font-size: 0.85rem;
  text-align: left;
}

.sql-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.sql-display-error strong {
  color: #667eea;
}

.btn-copy-sql {
  background: transparent;
  border: 1px solid #667eea;
  color: #667eea;
  padding: 0.3rem 0.6rem;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1rem;
  transition: all 0.2s ease;
}

.btn-copy-sql:hover {
  background: #667eea;
  transform: scale(1.1);
}

.sql-display-error code {
  color: rgba(255, 255, 255, 0.9);
  font-family: 'Courier New', monospace;
  word-break: break-all;
  white-space: pre-wrap;
  display: block;
}

/* Estilos para la card de valores únicos */
.card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 2rem 3rem;
  border-radius: 15px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.5);
  max-width: 400px;
  margin: 0 auto;
}

.card-label {
  font-size: 1.2rem;
  text-transform: uppercase;
  letter-spacing: 1px;
  margin-bottom: 0.5rem;
  opacity: 0.9;
}

.card-value {
  font-size: 3.5rem;
  font-weight: bold;
  text-align: center;
}

.card-empty {
  background: linear-gradient(135deg, #3a3a3a 0%, #2a2a2a 100%);
  border: 2px solid #4a4a4a;
}

.card-message {
  font-size: 1.1rem;
  text-align: center;
  opacity: 0.85;
  margin-top: 0.5rem;
}

/* Contenedor de tabla con scroll */
.table-container {
  width: 90%;
  max-width: 1200px;
  max-height: 600px;
  overflow: auto;
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
  border: 1px solid #3a3a3a;
}

/* Scrollbar personalizado */
.table-container::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

.table-container::-webkit-scrollbar-track {
  background: #1a1a1a;
  border-radius: 10px;
}

.table-container::-webkit-scrollbar-thumb {
  background: #667eea;
  border-radius: 10px;
}

.table-container::-webkit-scrollbar-thumb:hover {
  background: #764ba2;
}

/* Estilos para la tabla - Tema oscuro */
.data-table {
  width: 100%;
  min-width: 600px;
  border-collapse: collapse;
  background: #2a2a2a;
}

.data-table thead {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  position: sticky;
  top: 0;
  z-index: 10;
}

.data-table th {
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.9rem;
  letter-spacing: 0.5px;
}

.data-table td {
  padding: 1rem;
  border-bottom: 1px solid #3a3a3a;
  color: rgba(255, 255, 255, 0.87);
}

.data-table tbody tr:hover {
  background-color: #333333;
}

.data-table tbody tr:last-child td {
  border-bottom: none;
}

</style>
