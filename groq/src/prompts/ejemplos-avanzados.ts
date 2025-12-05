/**
 * Ejemplos avanzados de consultas SQL para Integria IMS
 * Estos ejemplos sirven como referencia para entrenar mejor a los modelos de IA
 * y para mantener un repositorio de consultas complejas del negocio
 */

export const CONSULTAS_AVANZADAS = {
    /**
     * INCIDENCIAS ABIERTAS POR GRUPOS ESPECÍFICOS
     * Grupos: 2=Operadores, 7=Técnicos, 8=Administradores, 148=Ciberseguridad
     * Criterio: fecha de cierre anterior a "0001-01-01" y estado diferente de 7 (cerrado)
     */
    incidenciasAbiertasPorGrupo: `
        SELECT id_incidencia, inicio, id_grupo
        FROM tincidencia
        WHERE cierre < "0001-01-01"
          AND id_grupo IN (2, 7, 8, 148)
          AND estado <> 7
        LIMIT 100
    `,

    /**
     * TODAS LAS INCIDENCIAS ABIERTAS AGRUPADAS POR CATEGORÍA
     * Agrupa múltiples id_grupo en categorías de negocio
     */
    todasIncidenciasAbiertasPorCategoria: `
        SELECT
            CASE
                WHEN id_grupo = 2 THEN 'Operadores'
                WHEN id_grupo = 7 THEN 'Tecnicos'
                WHEN id_grupo = 8 THEN 'Administradores'
                WHEN id_grupo = 148 THEN 'Ciberseguridad'
                WHEN id_grupo IN (19, 84, 86, 87, 122, 126, 149, 141, 21) THEN 'Apl.Horizontales'
                WHEN id_grupo IN (85, 20, 23, 40, 90, 91, 101, 43, 147) THEN 'Apl.Negocio'
                WHEN id_grupo IN (22, 24, 28, 31, 56, 154, 50, 52, 59, 32) THEN 'Tec.Externo'
                ELSE 'Otros'
            END AS grupo,
            COUNT(*) AS count
        FROM tincidencia
        WHERE cierre < "0001-01-01"
        GROUP BY grupo
        LIMIT 100
    `,

    /**
     * INCIDENCIAS CERRADAS EN RANGO DE FECHAS POR CATEGORÍA
     * Filtra por fecha de inicio y cierre válido (posterior a "0001-01-01")
     * Nota: Los parámetros ? deben ser reemplazados con fechas específicas
     */
    incidenciasCerradasPorCategoriaConFechas: `
        SELECT
            CASE
                WHEN id_grupo = 2 THEN 'Operadores'
                WHEN id_grupo = 7 THEN 'Tecnicos'
                WHEN id_grupo = 8 THEN 'Administradores'
                WHEN id_grupo = 148 THEN 'Ciberseguridad'
                WHEN id_grupo IN (19, 84, 86, 87, 122, 126, 149, 141, 21) THEN 'Apl.Horizontales'
                WHEN id_grupo IN (85, 20, 23, 40, 90, 91, 101, 43, 147) THEN 'Apl.Negocio'
                WHEN id_grupo IN (22, 24, 28, 31, 56, 154, 50, 52, 59, 32) THEN 'Tec.Externo'
                ELSE 'Otros'
            END AS grupo,
            COUNT(*) AS count
        FROM tincidencia
        WHERE inicio >= '2024-01-01'
          AND inicio <= DATE_ADD('2024-12-31', INTERVAL 1 DAY)
          AND cierre > '0001-01-01'
        GROUP BY grupo
        LIMIT 100
    `,
};

/**
 * MAPEO DE GRUPOS
 * Referencia para entender la estructura organizacional
 */
export const GRUPOS_MAPPING = {
    principales: {
        2: 'Operadores',
        7: 'Técnicos',
        8: 'Administradores',
        148: 'Ciberseguridad'
    },
    aplicacionesHorizontales: [19, 84, 86, 87, 122, 126, 149, 141, 21],
    aplicacionesNegocio: [85, 20, 23, 40, 90, 91, 101, 43, 147],
    tecnicosExternos: [22, 24, 28, 31, 56, 154, 50, 52, 59, 32]
};

/**
 * REGLAS DE NEGOCIO
 * Documentación de la lógica específica de Integria
 */
export const REGLAS_NEGOCIO = {
    incidencias: {
        estados: {
            7: 'Cerrado',
            otros: 'Abierto'
        },
        fechaCierre: {
            sinCerrar: '"0001-01-01" o menor',
            cerrada: 'Mayor a "0001-01-01"'
        }
    }
};

/**
 * TIPS PARA AGREGAR NUEVOS EJEMPLOS:
 *
 * 1. Documenta el propósito de la consulta con un comentario JSDoc
 * 2. Explica la lógica de negocio (estados, fechas especiales, etc.)
 * 3. Indica qué grupos o categorías se usan
 * 4. Si usa parámetros, explica qué valores se esperan
 * 5. Agrega la consulta a CONSULTAS_AVANZADAS
 *
 * Ejemplo:
 * ```typescript
 * miNuevaConsulta: `
 *     -- Descripción de lo que hace
 *     SELECT ...
 * `
 * ```
 */
