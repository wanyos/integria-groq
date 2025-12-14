# Guía de Modelos de IA

Este proyecto soporta múltiples modelos de IA para generar consultas SQL. Puedes cambiar entre ellos fácilmente mediante variables de entorno.

## Modelos Soportados

### 1. **Groq** (Por defecto)
- **Modelo**: `llama-3.3-70b-versatile`
- **Ventajas**: Rápido y eficiente
- **API Key**: Obtén tu clave en [https://console.groq.com](https://console.groq.com)

### 2. **Claude** (Anthropic)
- **Modelo**: `claude-3-5-sonnet-20241022`
- **Ventajas**: Excelente comprensión de contexto
- **API Key**: Obtén tu clave en [https://console.anthropic.com](https://console.anthropic.com)

### 3. **Gemini** (Google)
- **Modelo**: `gemini-1.5-flash`
- **Ventajas**: Buena relación velocidad/calidad
- **API Key**: Obtén tu clave en [https://makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey)

## Configuración

### Paso 1: Copiar archivo de ejemplo
```bash
cp .env.example .env
```

### Paso 2: Configurar las API Keys
Edita el archivo `.env` y añade las claves API de los modelos que quieras usar:

```env
# Modelo activo (groq, claude, gemini)
AI_MODEL=groq

# API Keys
GROQ_API_KEY=gsk_tu_clave_aqui
ANTHROPIC_API_KEY=sk-ant-tu_clave_aqui
GEMINI_API_KEY=AIza_tu_clave_aqui
```

### Paso 3: Instalar dependencias
Instala los SDKs necesarios según los modelos que vayas a usar:

```bash
# Groq (ya instalado)
npm install groq-sdk

# Claude
npm install @anthropic-ai/sdk

# Gemini
npm install @google/generative-ai
```

## Cambiar de Modelo

Para cambiar de modelo, simplemente modifica la variable `AI_MODEL` en tu archivo `.env`:

```env
# Usar Groq
AI_MODEL=groq

# Usar Claude
AI_MODEL=claude

# Usar Gemini
AI_MODEL=gemini
```

Luego reinicia el servidor:
```bash
npm run dev
```

## Estructura del Código

```
groq/src/
├── modelos-ia/
│   ├── types.ts          # Tipos compartidos
│   ├── groq.ts           # Implementación de Groq
│   ├── claude.ts         # Implementación de Claude
│   ├── gemini.ts         # Implementación de Gemini
│   └── index.ts          # Factory para crear proveedores
├── prompts/
│   └── system-prompt.ts  # Prompts del sistema
└── main.ts               # Servidor principal
```

## Añadir Nuevos Modelos

Para añadir un nuevo modelo de IA:

1. **Crear archivo en `modelos-ia/`**:
```typescript
// modelos-ia/nuevo-modelo.ts
import type { IAIProvider, AIResponse, AIModelConfig } from './types.js';

export class NuevoModeloProvider implements IAIProvider {
    name = 'nuevo-modelo' as const;

    async generateSQL(question: string, dbSchema: string, systemPrompt: string): Promise<AIResponse> {
        // Implementación
    }

    async testConnection(): Promise<boolean> {
        // Test de conexión
    }
}
```

2. **Actualizar el factory** en `modelos-ia/index.ts`:
```typescript
case 'nuevo-modelo':
    return new NuevoModeloProvider(config);
```

3. **Actualizar tipos** en `modelos-ia/types.ts`:
```typescript
export type AIModel = 'groq' | 'claude' | 'gemini' | 'nuevo-modelo';
```

## Respuesta de la API

Cuando haces una consulta, la API ahora incluye información sobre el modelo usado:

```json
{
  "success": true,
  "question": "Muéstrame las últimas incidencias",
  "sql": "SELECT * FROM tincidencia ORDER BY id_incidencia DESC LIMIT 10",
  "data": [...],
  "count": 10,
  "model": "llama-3.3-70b-versatile",
  "usage": {
    "promptTokens": 1234,
    "completionTokens": 56,
    "totalTokens": 1290
  }
}
```

## Comparación de Modelos

| Modelo | Velocidad | Precisión | Costo | Mejor para |
|--------|-----------|-----------|-------|------------|
| Groq (Llama) | ⚡⚡⚡ | ⭐⭐⭐ | 💰 | Consultas rápidas |
| Claude | ⚡⚡ | ⭐⭐⭐⭐⭐ | 💰💰💰 | Consultas complejas |
| Gemini | ⚡⚡⚡ | ⭐⭐⭐⭐ | 💰💰 | Uso general |

## Troubleshooting

### Error: "API Key no configurada"
- Verifica que la variable de entorno esté configurada correctamente
- Asegúrate de que el archivo `.env` esté en la raíz del proyecto

### Error: "Modelo de IA no soportado"
- Verifica que `AI_MODEL` sea uno de: `groq`, `claude`, `gemini`
- Revisa que no haya errores de tipeo en el `.env`

### El modelo no responde
- Verifica tu API key
- Comprueba tu conexión a internet
- Revisa los límites de tu plan API
