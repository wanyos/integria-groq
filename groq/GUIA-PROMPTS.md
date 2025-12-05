# Guía de Prompts y Ejemplos SQL

## 📚 Estructura de Prompts

El sistema de prompts está organizado en varios archivos:

```
src/prompts/
├── system-prompt.ts          # Prompt principal del sistema
└── ejemplos-avanzados.ts     # Repositorio de consultas complejas
```

## 🎯 ¿Por Qué Incluir Consultas SQL Complejas?

### ✅ Ventajas

1. **Mejora la precisión de las respuestas**
   - El modelo aprende patrones reales de tu base de datos
   - Entiende la lógica de negocio específica (estados, fechas, grupos)

2. **Reduce errores comunes**
   - Evita traducciones incorrectas de nombres de tabla
   - Respeta la estructura de datos real

3. **Aprende convenciones de negocio**
   - IDs de grupos y su significado
   - Estados especiales (ej: `cierre < "0001-01-01"` = no cerrada)
   - Categorizaciones personalizadas

4. **Acelera el desarrollo**
   - Menos iteraciones para obtener la consulta correcta
   - Mejor comprensión de consultas complejas

### ⚠️ Consideraciones

- El prompt tiene un límite de tokens (~8K-32K dependiendo del modelo)
- Incluye solo ejemplos **representativos** y **comunes**
- Documenta la lógica de negocio, no solo el SQL

## 📝 Cómo Agregar Nuevos Ejemplos

### 1. Ejemplos Simples (system-prompt.ts)

Para consultas frecuentes y conceptos básicos:

```typescript
// En src/prompts/system-prompt.ts
export const getSystemPrompt = (dbSchema: string): string => {
    return `...

    EJEMPLOS CORRECTOS:

    7. Tu nueva consulta simple:
    SELECT campo1, campo2 FROM tabla WHERE condicion LIMIT 10

    ...`;
};
```

### 2. Ejemplos Complejos (ejemplos-avanzados.ts)

Para consultas avanzadas que sirvan de referencia:

```typescript
// En src/prompts/ejemplos-avanzados.ts
export const CONSULTAS_AVANZADAS = {
    miNuevaConsulta: `
        -- Descripción de lo que hace
        SELECT
            campo1,
            CASE
                WHEN condicion THEN 'Valor'
                ELSE 'Otro'
            END AS categoria
        FROM tabla
        WHERE filtro
        GROUP BY categoria
        LIMIT 100
    `,
};
```

## 🔍 Ejemplos Actuales en el Sistema

### Sistema Prompt Principal

Incluye:
- ✅ Nombres exactos de tablas
- ✅ Campos clave de cada tabla
- ✅ Lógica de estados (7 = cerrado)
- ✅ Fechas especiales ("0001-01-01" = sin cerrar)
- ✅ Mapeo de grupos (Operadores=2, Técnicos=7, etc.)
- ✅ Ejemplos de CASE WHEN para categorización
- ✅ Consultas con GROUP BY y agregaciones

### Ejemplos Avanzados

Repositorio de:
- 📊 Consultas de análisis por grupo
- 📅 Filtros de fecha complejos
- 🏷️ Categorizaciones de negocio
- 📈 Agregaciones avanzadas

## 🎨 Mejores Prácticas

### ✅ HACER

1. **Documentar la lógica de negocio**
   ```typescript
   /**
    * INCIDENCIAS ABIERTAS
    * Criterio: cierre < "0001-01-01" significa que NO está cerrada
    * Estado: 7 = cerrado, otros = abierto
    */
   ```

2. **Incluir casos de uso reales**
   - Usa consultas que realmente funcionan en producción
   - Incluye los valores reales de IDs y categorías

3. **Mantener consistencia**
   - Usa los mismos alias (ej: `AS count`, `AS grupo`)
   - Aplica el mismo formato de fechas
   - Respeta los límites (LIMIT 100)

4. **Agrupar por tema**
   - Incidencias
   - Inventario
   - Usuarios
   - Reportes

### ❌ EVITAR

1. **No incluir todo**
   - No agregues TODAS tus consultas
   - Selecciona las más representativas

2. **No usar datos sensibles**
   - Evita nombres de usuarios reales
   - No incluyas datos confidenciales

3. **No crear prompts gigantes**
   - Más de 100 líneas de ejemplos es excesivo
   - Prioriza calidad sobre cantidad

4. **No olvidar actualizar**
   - Si cambias la estructura de BD, actualiza los ejemplos
   - Revisa periódicamente la relevancia

## 🔄 Flujo de Trabajo Recomendado

### 1. Detectar Consultas Problemáticas

```bash
# Revisa los logs del servidor
npm run dev

# Busca consultas que fallan frecuentemente
# o que el modelo genera incorrectamente
```

### 2. Agregar Ejemplo al Prompt

```typescript
// 1. Identifica el patrón
const consultaProblematica = `SELECT * FROM tincident`; // ❌ nombre incorrecto

// 2. Agrega el ejemplo correcto
const consultaCorrecta = `SELECT * FROM tincidencia`; // ✅ nombre correcto

// 3. Documenta en system-prompt.ts
```

### 3. Probar el Impacto

```bash
# Reinicia el servidor
npm run dev

# Haz la misma pregunta que falló antes
# Verifica que ahora genera el SQL correcto
```

### 4. Iterar

- Si el modelo sigue fallando, agrega más contexto
- Si funciona bien, considera agregar variaciones

## 📊 Ejemplos de Consultas por Categoría

### Incidencias Básicas

```sql
-- Últimas incidencias
SELECT * FROM tincidencia ORDER BY id_incidencia DESC LIMIT 10

-- Incidencias de un usuario
SELECT * FROM tincidencia WHERE id_usuario = 123 LIMIT 50

-- Incidencias por estado
SELECT estado, COUNT(*) as total FROM tincidencia GROUP BY estado LIMIT 100
```

### Incidencias Avanzadas

```sql
-- Incidencias abiertas por grupo
SELECT id_incidencia, inicio, id_grupo
FROM tincidencia
WHERE cierre < "0001-01-01" AND id_grupo IN (2, 7, 8, 148)
LIMIT 100

-- Tiempo promedio de resolución
SELECT
    AVG(TIMESTAMPDIFF(HOUR, inicio, cierre)) as horas_promedio
FROM tincidencia
WHERE cierre > "0001-01-01"
LIMIT 1
```

### Inventario

```sql
-- Inventario total por tipo
SELECT id_object_type, COUNT(*) as total
FROM tinventory
GROUP BY id_object_type
LIMIT 100

-- Búsqueda por descripción
SELECT name, description
FROM tinventory
WHERE description LIKE '%laptop%'
LIMIT 50
```

### Reportes con JOINs

```sql
-- Incidencias con nombre de usuario
SELECT
    t.id_incidencia,
    t.titulo,
    u.nombre_real
FROM tincidencia t
JOIN tusuario u ON t.id_usuario = u.id_usuario
LIMIT 50
```

## 🚀 Próximos Pasos

1. **Monitorea las consultas frecuentes**
   - Revisa qué preguntas hacen los usuarios
   - Identifica patrones comunes

2. **Agrega ejemplos incrementalmente**
   - No agregues todo de golpe
   - Prioriza lo que se usa más

3. **Mide el impacto**
   - ¿Mejoraron las respuestas?
   - ¿Se redujeron los errores?

4. **Mantén actualizado**
   - Revisa cada mes
   - Elimina ejemplos obsoletos
   - Agrega nuevos patrones

## 📚 Referencias

- [system-prompt.ts](src/prompts/system-prompt.ts) - Prompt principal
- [ejemplos-avanzados.ts](src/prompts/ejemplos-avanzados.ts) - Repositorio de consultas
- [MODELOS-IA.md](MODELOS-IA.md) - Guía de modelos de IA
