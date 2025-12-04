# Proyecto Groq - Fastify + MySQL

API REST con Fastify, TypeScript y MySQL.

## Requisitos

- Node.js 20.6+ (para soporte de `--env-file`)
- Docker (para la base de datos MySQL)
- npm

## Configuración inicial

### 1. Instalar dependencias

```bash
npm install
```

### 2. Configurar variables de entorno

Copia el archivo `.env` a `.env.local` y ajusta los valores:

```bash
cp .env .env.local
```

Edita `.env.local` con tus credenciales reales:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=integria_user
DB_PASSWORD=integria_pass
DB_NAME=integria
```

**Importante:** El archivo `.env.local` está en `.gitignore` y NO se debe subir al repositorio.

### 3. Iniciar base de datos MySQL

```bash
docker-compose up -d
```

Ver la documentación completa de la base de datos en [database/README.md](../database/README.md)

## Scripts disponibles

### Desarrollo

```bash
npm run dev
```

Inicia el servidor en modo desarrollo con hot-reload.

### Producción

```bash
# Compilar TypeScript
npm run build

# Ejecutar compilado
npm run start:prod
```

### Otros comandos

```bash
# Ejecutar una vez (sin watch)
npm start

# Compilar TypeScript
npm run build
```

## Estructura del proyecto

```
groq/
├── src/
│   ├── main.ts       # Punto de entrada, servidor Fastify
│   └── mysql.ts      # Configuración del pool de MySQL
├── database/         # Scripts SQL y docker-compose
├── .env              # Plantilla de variables (se sube a git)
├── .env.local        # Variables reales (NO se sube a git)
├── package.json
└── tsconfig.json
```

## Variables de entorno

El proyecto usa variables de entorno para la configuración. Todas las variables disponibles están documentadas en el archivo `.env`.

### ¿Por qué `.env` y `.env.local`?

- **`.env`**: Plantilla con valores de ejemplo. Se sube al repositorio como documentación.
- **`.env.local`**: Valores reales para tu entorno local. NO se sube al repositorio.

## API Endpoints

### GET /

Ruta de prueba básica.

**Respuesta:**
```
hello fastify
```

### GET /test-db

Prueba la conexión a la base de datos.

**Respuesta exitosa:**
```json
{
  "success": true,
  "data": [{"result": 2}]
}
```

**Respuesta con error:**
```json
{
  "success": false,
  "error": "Database connection failed"
}
```

## Desarrollo

### Añadir nuevas variables de entorno

1. Añade la variable en `.env` con un valor de ejemplo
2. Añade la variable en `.env.local` con el valor real
3. Úsala en el código con `process.env.TU_VARIABLE`

Ejemplo:

```typescript
// En cualquier archivo
const apiKey = process.env.API_KEY || 'default-key'
```

### Trabajar con la base de datos

```typescript
import { pool } from './mysql.js'

// Ejecutar query
const [rows] = await pool.query('SELECT * FROM tabla')

// Query con parámetros
const [rows] = await pool.query(
  'SELECT * FROM tabla WHERE id = ?',
  [id]
)
```

## Despliegue

En producción, asegúrate de:

1. Configurar las variables de entorno en tu plataforma (Heroku, Vercel, etc.)
2. NO incluir archivos `.env.local` en el repositorio
3. Usar `npm run build` y `npm run start:prod`

## Licencia

ISC
