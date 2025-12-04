# Chat SQL en Lenguaje Natural - Versión Simple

## ¿Qué vamos a hacer?

Crear un chat donde tus usuarios escriben preguntas en español y reciben datos de la base de datos.

```
Usuario escribe: "Muéstrame las incidencias abiertas"
    ↓
Backend pregunta a Claude: "Convierte esto a SQL"
    ↓
Claude responde: "SELECT * FROM incidencias WHERE estado = 'abierta'"
    ↓
Backend ejecuta el SQL en MySQL
    ↓
Backend devuelve los datos al frontend
    ↓
Frontend muestra una tabla con los resultados
```

---

## Paso 1: Configurar Backend (15 minutos)

### 1.1 Instalar librería de Claude

```bash
cd tu-backend
npm install @anthropic-ai/sdk
```

### 1.2 Obtener API Key

1. Ve a: https://console.anthropic.com/
2. Regístrate o inicia sesión
3. Ve a "API Keys"
4. Crea una nueva key
5. Cópiala

### 1.3 Agregar la key a tu `.env`

```env
ANTHROPIC_API_KEY=tu-key-aqui
```

### 1.4 Crear archivo de ruta (el más importante)

Crea el archivo `src/routes/chat.ts` (o el nombre que uses para rutas):

```typescript
import { Router } from 'express';
import Anthropic from '@anthropic-ai/sdk';
import mysql from 'mysql2/promise';

const router = Router();

// Inicializar Claude
const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY
});

// Endpoint principal
router.post('/consultar', async (req, res) => {
  try {
    const { pregunta } = req.body;

    // 1. Pedirle a Claude que convierta la pregunta a SQL
    const respuestaClaude = await anthropic.messages.create({
      model: 'claude-3-5-sonnet-20241022',
      max_tokens: 1024,
      messages: [{
        role: 'user',
        content: `Convierte esta pregunta a SQL:

Pregunta: "${pregunta}"

Base de datos:
- Tabla: incidencias (columnas: id, titulo, descripcion, estado, fecha_creacion)
- Tabla: inventario (columnas: id, nombre, categoria, cantidad, precio)
- Tabla: usuarios (columnas: id, nombre, email, rol, activo)

Reglas:
- Solo SELECT
- Agrega LIMIT 50
- Responde SOLO con el SQL, nada más

SQL:`
      }]
    });

    const sql = respuestaClaude.content[0].type === 'text'
      ? respuestaClaude.content[0].text.trim()
      : '';

    // 2. Ejecutar el SQL en MySQL
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME
    });

    const [rows] = await connection.execute(sql);
    await connection.end();

    // 3. Devolver resultados
    res.json({
      success: true,
      pregunta,
      sql,
      resultados: rows
    });

  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

export default router;
```

### 1.5 Registrar la ruta en tu app principal

En tu `app.ts` o `index.ts`:

```typescript
import chatRouter from './routes/chat';

app.use('/api/chat', chatRouter);
```

---

## Paso 2: Crear Frontend (20 minutos)

### 2.1 Crear componente Vue simple

Crea `src/views/ChatSQL.vue`:

```vue
<template>
  <div class="chat-container">
    <h1>Consulta la Base de Datos</h1>

    <!-- Resultados -->
    <div v-if="resultado" class="resultado">
      <h3>SQL Generado:</h3>
      <pre>{{ resultado.sql }}</pre>

      <h3>Resultados ({{ resultado.resultados.length }}):</h3>

      <div v-if="resultado.resultados.length === 0">
        No hay resultados
      </div>

      <table v-else>
        <thead>
          <tr>
            <th v-for="col in columnas" :key="col">{{ col }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(fila, i) in resultado.resultados" :key="i">
            <td v-for="col in columnas" :key="col">{{ fila[col] }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Error -->
    <div v-if="error" class="error">
      Error: {{ error }}
    </div>

    <!-- Input -->
    <div class="input-container">
      <input
        v-model="pregunta"
        @keyup.enter="consultar"
        placeholder="Ej: Muéstrame todas las incidencias abiertas"
      />
      <button @click="consultar" :disabled="cargando">
        {{ cargando ? 'Consultando...' : 'Consultar' }}
      </button>
    </div>

    <!-- Ejemplos -->
    <div class="ejemplos">
      <p><strong>Ejemplos:</strong></p>
      <button @click="pregunta = 'Muéstrame todas las incidencias abiertas'">
        Incidencias abiertas
      </button>
      <button @click="pregunta = 'Cuántos productos hay en inventario'">
        Total inventario
      </button>
      <button @click="pregunta = 'Lista los usuarios activos'">
        Usuarios activos
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

const pregunta = ref('');
const resultado = ref<any>(null);
const error = ref('');
const cargando = ref(false);

const columnas = computed(() => {
  if (!resultado.value?.resultados?.length) return [];
  return Object.keys(resultado.value.resultados[0]);
});

const consultar = async () => {
  if (!pregunta.value.trim()) return;

  cargando.value = true;
  error.value = '';
  resultado.value = null;

  try {
    const response = await fetch('http://localhost:3000/api/chat/consultar', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ pregunta: pregunta.value })
    });

    const data = await response.json();

    if (data.success) {
      resultado.value = data;
    } else {
      error.value = data.error;
    }
  } catch (err: any) {
    error.value = err.message;
  } finally {
    cargando.value = false;
  }
};
</script>

<style scoped>
.chat-container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
}

.resultado {
  background: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

pre {
  background: #2d2d2d;
  color: #f8f8f2;
  padding: 15px;
  border-radius: 4px;
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

th {
  background: #4CAF50;
  color: white;
}

tr:nth-child(even) {
  background: #f9f9f9;
}

.error {
  background: #ffebee;
  color: #c62828;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 20px;
}

.input-container {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

input {
  flex: 1;
  padding: 12px;
  font-size: 16px;
  border: 2px solid #ddd;
  border-radius: 4px;
}

button {
  padding: 12px 24px;
  background: #4CAF50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
}

button:hover:not(:disabled) {
  background: #45a049;
}

button:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.ejemplos {
  background: #e3f2fd;
  padding: 15px;
  border-radius: 4px;
}

.ejemplos button {
  margin: 5px;
  padding: 8px 16px;
  background: #2196F3;
  font-size: 14px;
}
</style>
```

### 2.2 Agregar ruta (si usas Vue Router)

En `router/index.ts`:

```typescript
import ChatSQL from '@/views/ChatSQL.vue';

const routes = [
  {
    path: '/chat-sql',
    name: 'ChatSQL',
    component: ChatSQL
  }
];
```

---

## Paso 3: Probar (5 minutos)

### 3.1 Iniciar backend

```bash
npm run dev
```

### 3.2 Iniciar frontend

```bash
npm run dev
```

### 3.3 Abrir en navegador

```
http://localhost:5173/chat-sql
```

### 3.4 Probar preguntas

- "Muéstrame todas las incidencias abiertas"
- "Cuántos productos hay en inventario"
- "Lista los usuarios activos"

---

## ¿Cómo funciona exactamente?

### Flujo completo paso a paso:

1. **Usuario escribe**: "Muéstrame las incidencias abiertas"

2. **Frontend envía**:
   ```json
   POST /api/chat/consultar
   { "pregunta": "Muéstrame las incidencias abiertas" }
   ```

3. **Backend pregunta a Claude**:
   ```
   "Convierte esta pregunta a SQL: Muéstrame las incidencias abiertas"
   ```

4. **Claude responde**:
   ```sql
   SELECT * FROM incidencias WHERE estado = 'abierta' LIMIT 50
   ```

5. **Backend ejecuta SQL en MySQL**:
   ```typescript
   const [rows] = await connection.execute(sql);
   ```

6. **Backend devuelve**:
   ```json
   {
     "success": true,
     "pregunta": "Muéstrame las incidencias abiertas",
     "sql": "SELECT * FROM incidencias WHERE estado = 'abierta' LIMIT 50",
     "resultados": [
       { "id": 1, "titulo": "Bug en login", "estado": "abierta" },
       { "id": 2, "titulo": "Error 404", "estado": "abierta" }
     ]
   }
   ```

7. **Frontend muestra tabla con los datos**

---

## Seguridad Básica (IMPORTANTE)

### Validación simple en backend

Agrega esto antes de ejecutar el SQL:

```typescript
// Validar que sea SELECT
if (!sql.toUpperCase().trim().startsWith('SELECT')) {
  return res.status(400).json({
    success: false,
    error: 'Solo se permiten consultas SELECT'
  });
}

// Validar comandos peligrosos
const peligrosos = ['DROP', 'DELETE', 'UPDATE', 'INSERT', 'ALTER'];
for (const cmd of peligrosos) {
  if (sql.toUpperCase().includes(cmd)) {
    return res.status(400).json({
      success: false,
      error: 'Comando no permitido'
    });
  }
}
```

---

## Mejoras Opcionales

### 1. Agregar historial de consultas

```typescript
const historial = ref<any[]>([]);

const consultar = async () => {
  // ... código existente ...

  if (data.success) {
    historial.value.unshift({
      fecha: new Date(),
      pregunta: pregunta.value,
      sql: data.sql,
      cantidad: data.resultados.length
    });
    resultado.value = data;
  }
};
```

### 2. Botón para copiar SQL

```vue
<button @click="copiarSQL">📋 Copiar SQL</button>

<script setup>
const copiarSQL = () => {
  navigator.clipboard.writeText(resultado.value.sql);
  alert('SQL copiado!');
};
</script>
```

### 3. Exportar a CSV

```typescript
const exportarCSV = () => {
  const headers = columnas.value.join(',');
  const rows = resultado.value.resultados.map(row =>
    columnas.value.map(col => row[col]).join(',')
  ).join('\n');

  const csv = `${headers}\n${rows}`;
  const blob = new Blob([csv], { type: 'text/csv' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'resultados.csv';
  a.click();
};
```

---

## Costos Aproximados

- Claude 3.5 Sonnet: ~$3 por millón de tokens
- Una consulta típica: ~300-500 tokens
- **Aproximadamente**: 2000-3000 consultas por $1 USD

---

## Resumen Ultra-Rápido

### Backend (1 archivo):
- `src/routes/chat.ts` - 60 líneas
- Recibe pregunta → llama Claude → ejecuta SQL → devuelve datos

### Frontend (1 archivo):
- `src/views/ChatSQL.vue` - 150 líneas
- Input + tabla de resultados

### Configuración:
- `.env` → agregar `ANTHROPIC_API_KEY`
- `npm install @anthropic-ai/sdk`

**Total**: 2 archivos, 1 dependencia, 15-20 minutos

---

## Troubleshooting

### "Error: API key not found"
- Verifica que agregaste `ANTHROPIC_API_KEY` al `.env`
- Reinicia el servidor backend

### "CORS error"
- Agrega en backend:
  ```typescript
  import cors from 'cors';
  app.use(cors());
  ```

### "ER_ACCESS_DENIED_ERROR"
- Verifica credenciales MySQL en `.env`

### Claude genera SQL incorrecto
- Mejora la descripción del esquema en el prompt
- Agrega más ejemplos de columnas
- Sé más específico en la pregunta

---

**¿Listo para empezar? Avísame si necesitas ayuda implementando alguna parte.**
