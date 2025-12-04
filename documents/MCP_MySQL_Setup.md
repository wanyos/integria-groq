# Guía Práctica: MCP MySQL para tu Aplicación Vue3 + Express

## Objetivo
Integrar un servidor MCP en tu aplicación existente (Vue3 + Express + MySQL2) para realizar consultas a la base de datos mediante lenguaje natural desde Claude Code.

---

## Paso 1: Agregar Servidor MCP a tu Aplicación

### 1.1 Ir a tu aplicación existente

```bash
# Ir al directorio raíz de tu aplicación backend (donde está Express)
cd tu-aplicacion-backend
```

### 1.2 Instalar dependencias MCP

```bash
# Instalar solo lo necesario para MCP
npm install @modelcontextprotocol/sdk zod

# mysql2 y dotenv ya deberías tenerlos instalados
# Si no los tienes: npm install mysql2 dotenv
```

### 1.3 Crear carpeta para MCP

```bash
# Crear carpeta dentro de tu backend
mkdir mcp-server
cd mcp-server
mkdir src
```

### 1.4 Estructura de archivos (dentro de tu aplicación)

```
tu-aplicacion-backend/
├── mcp-server/           # Nueva carpeta para MCP
│   ├── src/
│   │   ├── index.ts
│   │   ├── database.ts
│   │   ├── queryValidator.ts
│   │   ├── tools.ts
│   │   └── types.ts
│   └── tsconfig.json
├── src/                  # Tu código Express existente
├── .env                  # Tu archivo .env existente (lo usaremos)
├── package.json          # Tu package.json existente
└── ...
```

---

## Paso 2: Configurar Variables de Entorno

### 2.1 Agregar a tu `.env` existente

Abre tu archivo `.env` que ya tienes y agrega estas líneas al final:

```env
# Configuración MCP (agregar al final de tu .env existente)
ALLOWED_TABLES=incidencias,inventario,usuarios
MAX_QUERY_LIMIT=100
ENABLE_WRITES=false
```

**Tu .env ya tiene**: `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` (los usaremos)

### 2.2 Crear `tsconfig.json` para MCP

Crea el archivo `mcp-server/tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"]
}
```

---

## Paso 3: Crear Archivos del Servidor

### 3.1 `src/types.ts`

```typescript
export interface DatabaseConfig {
  host: string;
  port: number;
  user: string;
  password: string;
  database: string;
}

export interface QueryValidationResult {
  isValid: boolean;
  error?: string;
  queryType: 'SELECT' | 'INSERT' | 'UPDATE' | 'DELETE' | 'UNKNOWN';
}
```

### 3.2 `src/database.ts`

```typescript
import mysql from 'mysql2/promise';
import { DatabaseConfig } from './types.js';

let pool: mysql.Pool | null = null;

export function createPool(config: DatabaseConfig): mysql.Pool {
  if (pool) return pool;

  pool = mysql.createPool({
    host: config.host,
    port: config.port,
    user: config.user,
    password: config.password,
    database: config.database,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  });

  return pool;
}

export function getPool(): mysql.Pool {
  if (!pool) throw new Error('Database pool not initialized');
  return pool;
}

export async function testConnection(): Promise<boolean> {
  try {
    const connection = await getPool().getConnection();
    await connection.ping();
    connection.release();
    return true;
  } catch (error) {
    console.error('Database connection failed:', error);
    return false;
  }
}

export async function closePool(): Promise<void> {
  if (pool) {
    await pool.end();
    pool = null;
  }
}
```

### 3.3 `src/queryValidator.ts`

```typescript
import { QueryValidationResult } from './types.js';

const ALLOWED_TABLES = process.env.ALLOWED_TABLES?.split(',') || [];
const ENABLE_WRITES = process.env.ENABLE_WRITES === 'true';

export function validateQuery(query: string): QueryValidationResult {
  const trimmedQuery = query.trim().toUpperCase();

  let queryType: QueryValidationResult['queryType'] = 'UNKNOWN';
  if (trimmedQuery.startsWith('SELECT')) queryType = 'SELECT';
  else if (trimmedQuery.startsWith('INSERT')) queryType = 'INSERT';
  else if (trimmedQuery.startsWith('UPDATE')) queryType = 'UPDATE';
  else if (trimmedQuery.startsWith('DELETE')) queryType = 'DELETE';

  if (!ENABLE_WRITES && queryType !== 'SELECT') {
    return {
      isValid: false,
      error: 'Solo se permiten consultas SELECT',
      queryType
    };
  }

  const dangerousCommands = ['DROP', 'TRUNCATE', 'ALTER', 'CREATE', 'GRANT', 'REVOKE', 'LOAD_FILE', 'OUTFILE'];

  for (const cmd of dangerousCommands) {
    if (trimmedQuery.includes(cmd)) {
      return {
        isValid: false,
        error: `Comando prohibido: ${cmd}`,
        queryType
      };
    }
  }

  if (ALLOWED_TABLES.length > 0) {
    const hasAllowedTable = ALLOWED_TABLES.some(table =>
      trimmedQuery.includes(table.toUpperCase())
    );

    if (!hasAllowedTable) {
      return {
        isValid: false,
        error: `Solo se permite acceso a: ${ALLOWED_TABLES.join(', ')}`,
        queryType
      };
    }
  }

  return { isValid: true, queryType };
}

export function sanitizeQuery(query: string, maxLimit: number = 100): string {
  const trimmed = query.trim();
  const upper = trimmed.toUpperCase();

  if (upper.startsWith('SELECT') && !upper.includes('LIMIT')) {
    return `${trimmed} LIMIT ${maxLimit}`;
  }

  return trimmed;
}
```

### 3.4 `src/tools.ts`

```typescript
export const tools = {
  execute_query: {
    description: 'Ejecuta una consulta SQL en la base de datos',
    inputSchema: {
      type: 'object',
      properties: {
        query: {
          type: 'string',
          description: 'Consulta SQL a ejecutar'
        },
        params: {
          type: 'array',
          description: 'Parámetros para consulta preparada',
          items: { type: 'string' }
        }
      },
      required: ['query']
    }
  },

  list_tables: {
    description: 'Lista todas las tablas de la base de datos',
    inputSchema: {
      type: 'object',
      properties: {}
    }
  },

  describe_table: {
    description: 'Describe la estructura de una tabla',
    inputSchema: {
      type: 'object',
      properties: {
        tableName: {
          type: 'string',
          description: 'Nombre de la tabla'
        }
      },
      required: ['tableName']
    }
  },

  get_table_sample: {
    description: 'Obtiene 5 registros de ejemplo de una tabla',
    inputSchema: {
      type: 'object',
      properties: {
        tableName: {
          type: 'string',
          description: 'Nombre de la tabla'
        }
      },
      required: ['tableName']
    }
  }
};
```

### 3.5 `src/index.ts` (Archivo principal)

```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { CallToolRequestSchema, ListToolsRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import dotenv from 'dotenv';
import { createPool, getPool, testConnection, closePool } from './database.js';
import { validateQuery, sanitizeQuery } from './queryValidator.js';
import { tools } from './tools.js';
import { RowDataPacket } from 'mysql2';

dotenv.config();

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'test'
};

const MAX_QUERY_LIMIT = parseInt(process.env.MAX_QUERY_LIMIT || '100');

const server = new Server(
  {
    name: 'mysql-query-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

createPool(dbConfig);

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: Object.entries(tools).map(([name, tool]) => ({
      name,
      description: tool.description,
      inputSchema: tool.inputSchema
    }))
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case 'execute_query': {
        const { query, params } = args as { query: string; params?: any[] };

        const validation = validateQuery(query);
        if (!validation.isValid) {
          return {
            content: [{
              type: 'text',
              text: `Error: ${validation.error}`
            }]
          };
        }

        const sanitizedQuery = sanitizeQuery(query, MAX_QUERY_LIMIT);
        const [rows] = await getPool().execute(sanitizedQuery, params || []);

        return {
          content: [{
            type: 'text',
            text: JSON.stringify({
              success: true,
              rowCount: Array.isArray(rows) ? rows.length : 0,
              data: rows
            }, null, 2)
          }]
        };
      }

      case 'list_tables': {
        const [rows] = await getPool().query<RowDataPacket[]>('SHOW TABLES');
        const tables = rows.map(row => Object.values(row)[0]);

        return {
          content: [{
            type: 'text',
            text: JSON.stringify({ success: true, tables }, null, 2)
          }]
        };
      }

      case 'describe_table': {
        const { tableName } = args as { tableName: string };
        const [rows] = await getPool().query<RowDataPacket[]>('DESCRIBE ??', [tableName]);

        return {
          content: [{
            type: 'text',
            text: JSON.stringify({ success: true, table: tableName, columns: rows }, null, 2)
          }]
        };
      }

      case 'get_table_sample': {
        const { tableName } = args as { tableName: string };
        const [rows] = await getPool().query<RowDataPacket[]>('SELECT * FROM ?? LIMIT 5', [tableName]);

        return {
          content: [{
            type: 'text',
            text: JSON.stringify({ success: true, table: tableName, sample: rows }, null, 2)
          }]
        };
      }

      default:
        return {
          content: [{ type: 'text', text: `Herramienta desconocida: ${name}` }],
          isError: true
        };
    }
  } catch (error: any) {
    return {
      content: [{ type: 'text', text: `Error: ${error.message}` }],
      isError: true
    };
  }
});

async function main() {
  const connected = await testConnection();
  if (!connected) {
    console.error('No se pudo conectar a la base de datos');
    process.exit(1);
  }

  console.error('Conexión exitosa a MySQL');

  const transport = new StdioServerTransport();
  await server.connect(transport);

  console.error('Servidor MCP iniciado');
}

process.on('SIGINT', async () => {
  await closePool();
  process.exit(0);
});

process.on('SIGTERM', async () => {
  await closePool();
  process.exit(0);
});

main().catch((error) => {
  console.error('Error fatal:', error);
  process.exit(1);
});
```

### 3.6 Actualizar `package.json`

```json
{
  "name": "mcp-mysql-server",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsx src/index.ts"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0",
    "mysql2": "^3.6.0",
    "dotenv": "^16.3.1",
    "zod": "^3.22.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.3.0",
    "tsx": "^4.7.0"
  }
}
```

---

## Paso 4: Compilar y Probar

### 4.1 Agregar scripts a tu `package.json`

Abre tu `package.json` existente y agrega estos scripts:

```json
{
  "scripts": {
    "mcp:build": "tsc -p mcp-server/tsconfig.json",
    "mcp:dev": "tsx mcp-server/src/index.ts",
    "mcp:start": "node mcp-server/dist/index.js"
  }
}
```

### 4.2 Compilar el servidor MCP

```bash
npm run mcp:build
```

### 4.3 Probar en modo desarrollo

```bash
npm run mcp:dev
```

Deberías ver:
```
Conexión exitosa a MySQL
Servidor MCP iniciado
```

Si ves errores, verifica:
- Que tu aplicación Express puede conectarse a MySQL
- Las credenciales en `.env` son correctas
- MySQL está corriendo

---

## Paso 5: Integrar con Claude Code

### 5.1 Configurar Git Bash

```bash
# En PowerShell o CMD (ejecutar como administrador)
setx CLAUDE_CODE_GIT_BASH_PATH "C:\Program Files\Git\bin\bash.exe"
```

Cierra y abre VS Code completamente.

### 5.2 Agregar servidor MCP a Claude Code

```bash
# Reemplaza con la ruta real a tu aplicación backend
claude mcp add --transport stdio mysql-db -- node "C:\ruta\a\tu-backend\mcp-server\dist\index.js"
```

**Cómo obtener la ruta correcta:**
1. Abre tu terminal en la carpeta de tu aplicación backend
2. Ejecuta: `cd mcp-server && cd` (en Windows mostrará la ruta completa)
3. La ruta será algo como: `C:\Users\...\tu-app-backend\mcp-server`
4. Usa esa ruta + `\dist\index.js`

### 5.3 Verificar instalación

```bash
claude mcp list
```

Deberías ver:
```
mysql-db (stdio)
  Status: Connected
  Tools: execute_query, list_tables, describe_table, get_table_sample
```

### 5.4 Verificar en VS Code

En Claude Code dentro de VS Code, escribe:
```
/mcp
```

Deberías ver el servidor `mysql-db` listado y activo.

---

## Paso 6: Usar el Sistema

### Ejemplos de consultas en lenguaje natural

Una vez configurado, puedes hacer preguntas directamente:

**Ejemplo 1:**
```
Tú: "Muéstrame todas las incidencias abiertas"

Claude automáticamente ejecutará:
SELECT * FROM incidencias WHERE estado = 'abierta' LIMIT 100
```

**Ejemplo 2:**
```
Tú: "¿Cuántos productos hay en inventario por categoría?"

Claude ejecutará:
SELECT categoria, COUNT(*) as total FROM inventario GROUP BY categoria LIMIT 100
```

**Ejemplo 3:**
```
Tú: "Dame la estructura de la tabla usuarios"

Claude ejecutará:
DESCRIBE usuarios
```

**Ejemplo 4:**
```
Tú: "Muéstrame 5 ejemplos de registros de la tabla incidencias"

Claude ejecutará:
SELECT * FROM incidencias LIMIT 5
```

---

## Seguridad

### Usuario MySQL de solo lectura (RECOMENDADO)

```sql
-- Conectarte a MySQL como root
mysql -u root -p

-- Crear usuario específico para MCP
CREATE USER 'mcp_readonly'@'localhost' IDENTIFIED BY 'password_seguro_aqui';

-- Dar permisos SOLO de lectura
GRANT SELECT ON tu_base_datos.incidencias TO 'mcp_readonly'@'localhost';
GRANT SELECT ON tu_base_datos.inventario TO 'mcp_readonly'@'localhost';
GRANT SELECT ON tu_base_datos.usuarios TO 'mcp_readonly'@'localhost';

-- Aplicar
FLUSH PRIVILEGES;
```

Luego en `.env` usa:
```env
DB_USER=mcp_readonly
DB_PASSWORD=password_seguro_aqui
```

---

## Troubleshooting

### Problema: "Database pool not initialized"
**Solución**: Verifica credenciales en `.env` y que MySQL esté corriendo.

```bash
mysql -u tu_usuario -p -h localhost
```

### Problema: "Access denied"
**Solución**: Verifica usuario y contraseña en `.env`. Usa el usuario que tiene permisos en la base de datos.

### Problema: El servidor no aparece en `/mcp`
**Solución**:
1. Verifica que compilaste: `npm run build`
2. Verifica ruta en el comando `claude mcp add`
3. Recarga VS Code completamente
4. Revisa que Git Bash esté configurado

### Problema: Error al compilar
**Solución**: Verifica que instalaste todas las dependencias:
```bash
npm install
```

### Logs para debugging

```bash
# Ver logs en tiempo real
npm run dev

# Guardar logs
node dist/index.js 2>&1 | tee server.log
```

---

## Resumen Rápido

1. **Ir a tu backend**: `cd tu-aplicacion-backend`
2. **Instalar deps MCP**: `npm install @modelcontextprotocol/sdk zod && npm install -D tsx`
3. **Crear carpeta**: `mkdir mcp-server && cd mcp-server && mkdir src`
4. **Copiar archivos**: Los 5 archivos TypeScript en `mcp-server/src/`
5. **Crear tsconfig.json**: En `mcp-server/tsconfig.json`
6. **Agregar a .env**: Variables `ALLOWED_TABLES`, `MAX_QUERY_LIMIT`, `ENABLE_WRITES`
7. **Agregar scripts**: En tu `package.json` los scripts `mcp:build`, `mcp:dev`
8. **Compilar**: `npm run mcp:build`
9. **Configurar Git Bash**: `setx CLAUDE_CODE_GIT_BASH_PATH "C:\Program Files\Git\bin\bash.exe"`
10. **Agregar a Claude**: `claude mcp add --transport stdio mysql-db -- node "ruta\mcp-server\dist\index.js"`
11. **Verificar**: `/mcp` en Claude Code
12. **Usar**: Hacer consultas en lenguaje natural

---

## Checklist Final

- [ ] Carpeta `mcp-server` creada dentro de tu backend
- [ ] Dependencias MCP instaladas (`@modelcontextprotocol/sdk`, `zod`, `tsx`)
- [ ] 5 archivos TypeScript creados en `mcp-server/src/`
- [ ] `tsconfig.json` creado en `mcp-server/`
- [ ] Variables MCP agregadas a tu `.env` existente
- [ ] Scripts `mcp:*` agregados a tu `package.json`
- [ ] Compilación exitosa (`npm run mcp:build`)
- [ ] Prueba en dev funciona (`npm run mcp:dev`)
- [ ] Git Bash configurado
- [ ] Servidor agregado a Claude Code con la ruta correcta
- [ ] `/mcp` muestra el servidor activo
- [ ] Primera consulta de prueba funciona

---

**Versión**: 1.0.0
**Fecha**: 2025-12-03
