# Consultas en Lenguaje Natural - Guía Simple

## Objetivo
Agregar un chat en tu aplicación Vue3 donde los usuarios puedan hacer consultas a la base de datos en lenguaje natural (español) y obtener resultados.

---

## Arquitectura Simple

```
Usuario escribe en Vue3
     ↓
"Muéstrame las incidencias abiertas"
     ↓
Frontend envía a API Express
     ↓
Backend llama a API de Claude
     ↓
Claude convierte a SQL
     ↓
Backend ejecuta SQL en MySQL
     ↓
Backend devuelve resultados
     ↓
Frontend muestra los datos
```

---

## Paso 1: Backend - Endpoint para Consultas

### 1.1 Instalar dependencia de Anthropic

```bash
cd tu-backend
npm install @anthropic-ai/sdk
```

### 1.2 Agregar API Key a `.env`

```env
ANTHROPIC_API_KEY=tu_api_key_de_claude
```

Obtén tu API key en: https://console.anthropic.com/

### 1.3 Crear archivo `src/routes/queryChat.ts` (o similar)

```typescript
import { Router } from 'express';
import Anthropic from '@anthropic-ai/sdk';
import mysql from 'mysql2/promise';

const router = Router();

// Tu pool de MySQL existente (importa el que ya tienes)
// import { pool } from '../database';
// O crea uno aquí si no lo tienes centralizado

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY
});

// Información del esquema de tu base de datos
const DATABASE_SCHEMA = `
Base de datos: Sistema de gestión

Tablas disponibles:

1. incidencias
   - id (INT, PRIMARY KEY)
   - titulo (VARCHAR)
   - descripcion (TEXT)
   - estado (ENUM: 'abierta', 'en_proceso', 'cerrada')
   - prioridad (ENUM: 'baja', 'media', 'alta')
   - fecha_creacion (DATETIME)
   - fecha_actualizacion (DATETIME)
   - usuario_id (INT, FOREIGN KEY)

2. inventario
   - id (INT, PRIMARY KEY)
   - nombre (VARCHAR)
   - categoria (VARCHAR)
   - cantidad (INT)
   - precio (DECIMAL)
   - fecha_ingreso (DATE)

3. usuarios
   - id (INT, PRIMARY KEY)
   - nombre (VARCHAR)
   - email (VARCHAR)
   - rol (ENUM: 'admin', 'usuario', 'invitado')
   - activo (BOOLEAN)
   - fecha_registro (DATETIME)
`;

interface QueryRequest {
  pregunta: string;
}

router.post('/query', async (req, res) => {
  try {
    const { pregunta }: QueryRequest = req.body;

    if (!pregunta) {
      return res.status(400).json({ error: 'La pregunta es requerida' });
    }

    // 1. Llamar a Claude para convertir lenguaje natural a SQL
    const message = await anthropic.messages.create({
      model: 'claude-3-5-sonnet-20241022',
      max_tokens: 1024,
      messages: [{
        role: 'user',
        content: `Eres un experto en SQL. Convierte la siguiente pregunta en español a una consulta SQL.

${DATABASE_SCHEMA}

REGLAS IMPORTANTES:
- Solo genera consultas SELECT (no INSERT, UPDATE, DELETE)
- Agrega LIMIT 100 al final si no se especifica
- Devuelve SOLO la consulta SQL, sin explicaciones
- Usa nombres de columnas exactos del esquema
- Si la pregunta no es clara, genera una consulta segura

Pregunta del usuario: "${pregunta}"

Consulta SQL:`
      }]
    });

    const sqlQuery = message.content[0].type === 'text'
      ? message.content[0].text.trim()
      : '';

    // Validar que sea SELECT
    if (!sqlQuery.toUpperCase().startsWith('SELECT')) {
      return res.status(400).json({
        error: 'Solo se permiten consultas de lectura'
      });
    }

    // 2. Ejecutar la consulta en MySQL
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME
    });

    const [rows] = await connection.execute(sqlQuery);
    await connection.end();

    // 3. Devolver resultados
    return res.json({
      success: true,
      pregunta,
      sqlGenerado: sqlQuery,
      resultados: rows,
      cantidad: Array.isArray(rows) ? rows.length : 0
    });

  } catch (error: any) {
    console.error('Error en consulta:', error);
    return res.status(500).json({
      error: 'Error al procesar la consulta',
      detalle: error.message
    });
  }
});

export default router;
```

### 1.4 Registrar la ruta en tu `app.ts` o `index.ts`

```typescript
import queryChatRouter from './routes/queryChat';

app.use('/api/chat', queryChatRouter);
```

---

## Paso 2: Frontend - Componente de Chat

### 2.1 Crear componente `ChatQuery.vue`

```vue
<template>
  <div class="chat-container">
    <h2>Consulta a la Base de Datos</h2>

    <!-- Historial de consultas -->
    <div class="chat-history" ref="chatHistory">
      <div
        v-for="(item, index) in historial"
        :key="index"
        class="chat-message"
      >
        <div class="user-message">
          <strong>Tú:</strong> {{ item.pregunta }}
        </div>

        <div v-if="item.loading" class="loading">
          Procesando consulta...
        </div>

        <div v-else-if="item.error" class="error-message">
          <strong>Error:</strong> {{ item.error }}
        </div>

        <div v-else class="assistant-message">
          <div class="sql-query">
            <strong>SQL generado:</strong>
            <code>{{ item.sqlGenerado }}</code>
          </div>

          <div class="results">
            <strong>Resultados ({{ item.cantidad }}):</strong>

            <div v-if="item.cantidad === 0" class="no-results">
              No se encontraron resultados
            </div>

            <table v-else class="results-table">
              <thead>
                <tr>
                  <th v-for="col in Object.keys(item.resultados[0])" :key="col">
                    {{ col }}
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, idx) in item.resultados" :key="idx">
                  <td v-for="col in Object.keys(row)" :key="col">
                    {{ row[col] }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Input de pregunta -->
    <div class="chat-input">
      <input
        v-model="pregunta"
        @keyup.enter="enviarConsulta"
        placeholder="Ej: Muéstrame todas las incidencias abiertas"
        :disabled="enviando"
      />
      <button @click="enviarConsulta" :disabled="enviando || !pregunta">
        {{ enviando ? 'Enviando...' : 'Enviar' }}
      </button>
    </div>

    <!-- Ejemplos -->
    <div class="ejemplos">
      <p><strong>Ejemplos de consultas:</strong></p>
      <ul>
        <li @click="pregunta = 'Muéstrame todas las incidencias abiertas'">
          Muéstrame todas las incidencias abiertas
        </li>
        <li @click="pregunta = '¿Cuántos productos hay en inventario por categoría?'">
          ¿Cuántos productos hay en inventario por categoría?
        </li>
        <li @click="pregunta = 'Lista los usuarios activos ordenados por fecha de registro'">
          Lista los usuarios activos ordenados por fecha de registro
        </li>
        <li @click="pregunta = 'Incidencias de prioridad alta del último mes'">
          Incidencias de prioridad alta del último mes
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, nextTick } from 'vue';

interface HistorialItem {
  pregunta: string;
  sqlGenerado?: string;
  resultados?: any[];
  cantidad?: number;
  error?: string;
  loading?: boolean;
}

const pregunta = ref('');
const enviando = ref(false);
const historial = ref<HistorialItem[]>([]);
const chatHistory = ref<HTMLElement>();

const enviarConsulta = async () => {
  if (!pregunta.value.trim() || enviando.value) return;

  const item: HistorialItem = {
    pregunta: pregunta.value,
    loading: true
  };

  historial.value.push(item);
  const preguntaActual = pregunta.value;
  pregunta.value = '';
  enviando.value = true;

  // Scroll automático
  await nextTick();
  chatHistory.value?.scrollTo(0, chatHistory.value.scrollHeight);

  try {
    const response = await fetch('http://localhost:3000/api/chat/query', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        // Agregar token si usas autenticación
        // 'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({ pregunta: preguntaActual })
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || 'Error al procesar consulta');
    }

    // Actualizar el item con los resultados
    item.loading = false;
    item.sqlGenerado = data.sqlGenerado;
    item.resultados = data.resultados;
    item.cantidad = data.cantidad;

  } catch (error: any) {
    item.loading = false;
    item.error = error.message;
  } finally {
    enviando.value = false;
    await nextTick();
    chatHistory.value?.scrollTo(0, chatHistory.value.scrollHeight);
  }
};
</script>

<style scoped>
.chat-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.chat-history {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 20px;
  height: 500px;
  overflow-y: auto;
  margin-bottom: 20px;
  background: #f9f9f9;
}

.chat-message {
  margin-bottom: 20px;
  padding: 15px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.user-message {
  color: #2563eb;
  margin-bottom: 10px;
}

.assistant-message {
  color: #333;
}

.sql-query {
  margin-bottom: 15px;
  padding: 10px;
  background: #f1f5f9;
  border-radius: 4px;
}

.sql-query code {
  display: block;
  padding: 10px;
  background: #1e293b;
  color: #e2e8f0;
  border-radius: 4px;
  overflow-x: auto;
  font-family: 'Courier New', monospace;
  font-size: 14px;
}

.results-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}

.results-table th,
.results-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

.results-table th {
  background: #f1f5f9;
  font-weight: bold;
}

.results-table tr:nth-child(even) {
  background: #f9f9f9;
}

.loading {
  color: #64748b;
  font-style: italic;
}

.error-message {
  color: #dc2626;
  padding: 10px;
  background: #fee2e2;
  border-radius: 4px;
}

.no-results {
  color: #64748b;
  font-style: italic;
  padding: 10px;
}

.chat-input {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.chat-input input {
  flex: 1;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 16px;
}

.chat-input button {
  padding: 12px 24px;
  background: #2563eb;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
}

.chat-input button:hover:not(:disabled) {
  background: #1d4ed8;
}

.chat-input button:disabled {
  background: #94a3b8;
  cursor: not-allowed;
}

.ejemplos {
  padding: 15px;
  background: #f1f5f9;
  border-radius: 8px;
}

.ejemplos ul {
  list-style: none;
  padding: 0;
}

.ejemplos li {
  padding: 8px 12px;
  margin: 5px 0;
  background: white;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.2s;
}

.ejemplos li:hover {
  background: #e2e8f0;
}
</style>
```

### 2.2 Agregar el componente a tu router (si usas Vue Router)

```typescript
// router/index.ts
import ChatQuery from '@/views/ChatQuery.vue';

const routes = [
  // ... tus rutas existentes
  {
    path: '/consultas',
    name: 'Consultas',
    component: ChatQuery
  }
];
```

---

## Paso 3: Configurar CORS (si es necesario)

En tu backend Express, si frontend y backend están en puertos diferentes:

```typescript
import cors from 'cors';

app.use(cors({
  origin: 'http://localhost:5173', // Puerto de tu Vue dev server
  credentials: true
}));
```

---

## Paso 4: Probar

### 4.1 Iniciar backend
```bash
npm run dev
```

### 4.2 Iniciar frontend
```bash
npm run dev
```

### 4.3 Ir a la ruta del chat
```
http://localhost:5173/consultas
```

### 4.4 Probar consultas
- "Muéstrame todas las incidencias abiertas"
- "¿Cuántos productos hay en inventario?"
- "Lista los usuarios activos"

---

## Mejoras Opcionales

### 1. Agregar Autenticación

```typescript
// Middleware de autenticación
const authMiddleware = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No autorizado' });
  // Verificar token...
  next();
};

router.post('/query', authMiddleware, async (req, res) => {
  // ...
});
```

### 2. Limitar Consultas por Usuario

```typescript
// Rate limiting
import rateLimit from 'express-rate-limit';

const queryLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 20 // 20 consultas por ventana
});

router.post('/query', queryLimiter, async (req, res) => {
  // ...
});
```

### 3. Historial de Consultas

```typescript
// Guardar consultas en base de datos
await connection.execute(
  'INSERT INTO historial_consultas (usuario_id, pregunta, sql_generado, fecha) VALUES (?, ?, ?, NOW())',
  [userId, pregunta, sqlQuery]
);
```

### 4. Exportar Resultados

```typescript
// Agregar botón en Vue para exportar a CSV
const exportarCSV = (resultados: any[]) => {
  const headers = Object.keys(resultados[0]).join(',');
  const rows = resultados.map(row =>
    Object.values(row).join(',')
  ).join('\n');

  const csv = `${headers}\n${rows}`;
  const blob = new Blob([csv], { type: 'text/csv' });
  const url = window.URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'resultados.csv';
  a.click();
};
```

---

## Seguridad Importante

### ✅ Implementado:
- Solo consultas SELECT
- LIMIT automático
- Validación de entrada

### ⚠️ Recomendaciones adicionales:
1. **Autenticación**: Requiere usuario logueado
2. **Rate limiting**: Limita consultas por usuario
3. **Logs**: Guarda todas las consultas realizadas
4. **Permisos**: Define qué tablas puede consultar cada rol
5. **Sanitización**: Valida que el SQL generado sea seguro

### Ejemplo de validación avanzada:

```typescript
const TABLAS_PERMITIDAS = ['incidencias', 'inventario', 'usuarios'];

const validarSQL = (sql: string): boolean => {
  const sqlUpper = sql.toUpperCase();

  // No permitir múltiples statements
  if (sql.includes(';') && sql.lastIndexOf(';') < sql.length - 1) {
    return false;
  }

  // Verificar que solo acceda a tablas permitidas
  const tablasMencionadas = TABLAS_PERMITIDAS.filter(tabla =>
    sqlUpper.includes(tabla.toUpperCase())
  );

  if (tablasMencionadas.length === 0) {
    return false;
  }

  return true;
};
```

---

## Costos de API

- Claude 3.5 Sonnet: ~$3 por millón de tokens de entrada
- Una consulta típica usa ~500 tokens
- 1000 consultas ≈ $1.50

---

## Resumen

1. **Backend**: Endpoint que recibe pregunta → Claude convierte a SQL → ejecuta → devuelve resultados
2. **Frontend**: Chat donde usuario escribe en lenguaje natural → muestra SQL generado y resultados
3. **Simple**: Solo 2 archivos nuevos (ruta backend + componente Vue)
4. **Seguro**: Validaciones y limitaciones implementadas

¿Necesitas ayuda implementando alguna parte específica?
