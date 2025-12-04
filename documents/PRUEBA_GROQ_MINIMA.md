# Prueba Mínima con Groq - Chat SQL

## Configuración Rápida (5 minutos)

### Paso 1: Instalar dependencia

```bash
npm install groq-sdk
```

### Paso 2: Agregar API Key al `.env`

Abre tu `.env` y agrega:

```env
GROQ_API_KEY=tu_api_key_aqui
```

### Paso 3: Crear archivo de prueba

Crea `src/routes/chatGroq.ts` (o el nombre que uses para rutas):

```typescript
import { Router } from 'express';
import Groq from 'groq-sdk';
import mysql from 'mysql2/promise';

const router = Router();

// Inicializar Groq
const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY
});

// Esquema mínimo (ajusta a tus tablas)
const SCHEMA = `
TABLAS:
- usuarios: id, nombre, email, rol, activo
- incidencias: id, titulo, descripcion, estado, prioridad, fecha_creacion
- inventario: id, nombre, categoria, cantidad, precio
`;

// Endpoint principal
router.post('/consultar', async (req, res) => {
  try {
    const { pregunta } = req.body;

    console.log('📝 Pregunta:', pregunta);

    // 1. Llamar a Groq
    const completion = await groq.chat.completions.create({
      messages: [{
        role: "user",
        content: `Convierte esta pregunta a SQL MySQL.

${SCHEMA}

REGLAS:
- Solo SELECT
- Agrega LIMIT 50
- Responde SOLO el SQL

Pregunta: "${pregunta}"

SQL:`
      }],
      model: "llama-3.1-70b-versatile",
      temperature: 0.1,
      max_tokens: 500
    });

    let sql = completion.choices[0]?.message?.content?.trim() || '';

    // Limpiar markdown si lo tiene
    sql = sql.replace(/```sql/g, '').replace(/```/g, '').trim();

    console.log('🤖 SQL generado:', sql);

    // 2. Validación básica
    if (!sql.toUpperCase().startsWith('SELECT')) {
      return res.status(400).json({
        success: false,
        error: 'Solo consultas SELECT permitidas'
      });
    }

    // 3. Ejecutar en MySQL
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME
    });

    const [rows] = await connection.execute(sql);
    await connection.end();

    console.log('✅ Resultados:', Array.isArray(rows) ? rows.length : 0);

    // 4. Devolver resultados
    res.json({
      success: true,
      pregunta,
      sql,
      resultados: rows,
      cantidad: Array.isArray(rows) ? rows.length : 0
    });

  } catch (error: any) {
    console.error('❌ Error:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

export default router;
```

### Paso 4: Registrar la ruta

En tu `app.ts` o `index.ts`:

```typescript
import chatGroqRouter from './routes/chatGroq';

app.use('/api/groq', chatGroqRouter);
```

### Paso 5: Probar con cURL o Postman

```bash
# Iniciar tu servidor
npm run dev

# En otra terminal, probar:
curl -X POST http://localhost:3000/api/groq/consultar \
  -H "Content-Type: application/json" \
  -d '{"pregunta": "Muéstrame todos los usuarios activos"}'
```

O con Postman:
- **URL**: `POST http://localhost:3000/api/groq/consultar`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "pregunta": "Muéstrame todos los usuarios activos"
}
```

---

## Frontend Vue (Opcional)

Si quieres probarlo desde el frontend, crea `src/views/TestGroq.vue`:

```vue
<template>
  <div style="max-width: 800px; margin: 50px auto; padding: 20px;">
    <h1>🧪 Prueba Groq SQL</h1>

    <!-- Input -->
    <div style="margin: 20px 0;">
      <input
        v-model="pregunta"
        @keyup.enter="consultar"
        placeholder="Ej: Muéstrame todos los usuarios activos"
        style="width: 100%; padding: 12px; font-size: 16px;"
      />
      <button
        @click="consultar"
        :disabled="cargando"
        style="margin-top: 10px; padding: 12px 24px; font-size: 16px;"
      >
        {{ cargando ? 'Consultando...' : 'Consultar' }}
      </button>
    </div>

    <!-- SQL Generado -->
    <div v-if="resultado" style="background: #f5f5f5; padding: 15px; margin: 20px 0;">
      <strong>SQL Generado:</strong>
      <pre style="background: #2d2d2d; color: #fff; padding: 10px; overflow-x: auto;">{{ resultado.sql }}</pre>
    </div>

    <!-- Resultados -->
    <div v-if="resultado?.resultados?.length">
      <strong>Resultados ({{ resultado.cantidad }}):</strong>
      <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
        <thead>
          <tr style="background: #4CAF50; color: white;">
            <th v-for="col in columnas" :key="col" style="border: 1px solid #ddd; padding: 8px;">
              {{ col }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(fila, i) in resultado.resultados" :key="i">
            <td v-for="col in columnas" :key="col" style="border: 1px solid #ddd; padding: 8px;">
              {{ fila[col] }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Error -->
    <div v-if="error" style="background: #ffebee; color: #c62828; padding: 15px; margin: 20px 0;">
      Error: {{ error }}
    </div>

    <!-- Ejemplos -->
    <div style="margin-top: 30px;">
      <strong>Ejemplos rápidos:</strong>
      <div style="display: flex; gap: 10px; margin-top: 10px; flex-wrap: wrap;">
        <button @click="pregunta = 'Muéstrame todos los usuarios activos'">
          Usuarios activos
        </button>
        <button @click="pregunta = 'Cuántas incidencias abiertas hay'">
          Incidencias abiertas
        </button>
        <button @click="pregunta = 'Lista el inventario con menos de 10 unidades'">
          Inventario bajo
        </button>
      </div>
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
    const response = await fetch('http://localhost:3000/api/groq/consultar', {
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
```

---

## Verificar que funciona

### 1. Verificar API Key
```bash
# En tu terminal, verifica que la variable está cargada
node -e "require('dotenv').config(); console.log('GROQ_API_KEY:', process.env.GROQ_API_KEY ? '✅ Configurada' : '❌ No encontrada')"
```

### 2. Test rápido del endpoint

Crea un archivo `test-groq.js`:

```javascript
const Groq = require('groq-sdk').default;
require('dotenv').config();

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY
});

async function test() {
  try {
    const completion = await groq.chat.completions.create({
      messages: [{
        role: "user",
        content: "Convierte a SQL: Muéstrame todos los usuarios"
      }],
      model: "llama-3.1-70b-versatile",
      temperature: 0.1,
      max_tokens: 100
    });

    console.log('✅ Groq funciona!');
    console.log('SQL:', completion.choices[0]?.message?.content);
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

test();
```

Ejecutar:
```bash
node test-groq.js
```

---

## Modelos Groq disponibles

Puedes cambiar el modelo en el código:

```typescript
// Más rápido, buena calidad
model: "llama-3.1-70b-versatile"

// Más pequeño, aún más rápido
model: "llama-3.1-8b-instant"

// Mejor para razonamiento
model: "llama-3.1-405b-reasoning"

// Alternativa
model: "mixtral-8x7b-32768"
```

---

## Límites del Tier Gratuito

- **14,400 requests por día**
- **30 requests por minuto**
- Totalmente gratis

Si excedes:
- Te cobra según uso
- Muy barato: ~$0.04 por 1000 consultas

---

## Troubleshooting

### Error: "API key not found"
```bash
# Verifica tu .env
cat .env | grep GROQ_API_KEY

# Reinicia el servidor
npm run dev
```

### Error: "Rate limit exceeded"
- Espera 1 minuto
- O agrega delay entre requests

### Error: "Invalid API key"
- Verifica la key en: https://console.groq.com/keys
- Regenera si es necesario

---

## Comparación rápida con Claude

```typescript
// CLAUDE (lo que tenías)
const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
const message = await anthropic.messages.create({
  model: 'claude-3-5-sonnet-20241022',
  messages: [{ role: 'user', content: prompt }]
});
const sql = message.content[0].text;

// GROQ (más barato y rápido)
const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });
const completion = await groq.chat.completions.create({
  model: 'llama-3.1-70b-versatile',
  messages: [{ role: 'user', content: prompt }]
});
const sql = completion.choices[0]?.message?.content;
```

**Diferencias:**
- Groq: 15x más barato, 3-5x más rápido
- Claude: Ligeramente mejor calidad en casos complejos

---

## Resumen Ultra-Rápido

```bash
# 1. Instalar
npm install groq-sdk

# 2. Agregar al .env
GROQ_API_KEY=tu_key_aqui

# 3. Copiar el código del archivo chatGroq.ts

# 4. Registrar ruta en app.ts

# 5. Probar
curl -X POST http://localhost:3000/api/groq/consultar \
  -H "Content-Type: application/json" \
  -d '{"pregunta": "Muéstrame todos los usuarios"}'
```

**Total**: 1 archivo, 1 dependencia, 5 minutos ⚡

---

¿Listo para probar? Avísame si necesitas ayuda con algún paso.
