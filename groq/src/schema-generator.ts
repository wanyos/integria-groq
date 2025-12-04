import { pool } from './mysql.js';
import { analyzeDatabase } from './schema-analyzer.js';

interface TableColumn {
    Field: string;
    Type: string;
    Null: string;
    Key: string;
    Default: string | null;
    Extra: string;
}

interface TableInfo {
    name: string;
    columns: TableColumn[];
    foreignKeys: string[];
}

let cachedSchema: string | null = null;
let lastCacheTime: number = 0;
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutos

/**
 * Genera el schema completo de la base de datos
 */
export async function getDatabaseSchema(): Promise<string> {
    // Usar cache si está disponible y no ha expirado
    const now = Date.now();
    if (cachedSchema && (now - lastCacheTime) < CACHE_DURATION) {
        return cachedSchema;
    }

    try {
        // 1. Obtener todas las tablas
        const [tables] = await pool.query<any[]>('SHOW TABLES');
        const tableNames = tables.map((row: any) => Object.values(row)[0] as string);

        const tablesInfo: TableInfo[] = [];

        // 2. Para cada tabla, obtener columnas y foreign keys
        for (const tableName of tableNames) {
            // Obtener columnas
            const [columns] = await pool.query(`DESCRIBE ${tableName}`) as [TableColumn[], any];

            // Obtener foreign keys
            const [fks] = await pool.query<any[]>(`
                SELECT
                    CONSTRAINT_NAME,
                    COLUMN_NAME,
                    REFERENCED_TABLE_NAME,
                    REFERENCED_COLUMN_NAME
                FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                WHERE TABLE_SCHEMA = DATABASE()
                    AND TABLE_NAME = ?
                    AND REFERENCED_TABLE_NAME IS NOT NULL
            `, [tableName]);

            const foreignKeys = fks.map((fk: any) =>
                `${fk.COLUMN_NAME} -> ${fk.REFERENCED_TABLE_NAME}(${fk.REFERENCED_COLUMN_NAME})`
            );

            tablesInfo.push({
                name: tableName,
                columns,
                foreignKeys
            });
        }

        // 3. Analizar la base de datos para identificar tablas importantes
        const { coreTables } = await analyzeDatabase();

        // 4. Generar el schema en formato ultra compacto
        let schema = `DB: integria (Incidencias/Inventario/Usuarios)

NOMBRES EXACTOS DE TABLAS (usar tal cual):\n`;

        // Primero las tablas principales identificadas automáticamente
        for (const tableName of coreTables.slice(0, 8)) { // Top 8 tablas
            const table = tablesInfo.find(t => t.name === tableName);
            if (!table) continue;

            schema += `\n${table.name}(`;

            // Solo PK y primeros 3-4 campos
            const cols = table.columns.slice(0, 4).map(col => {
                let n = col.Field;
                if (col.Key === 'PRI') n += '*';
                return n;
            });

            schema += cols.join(', ');
            if (table.columns.length > 4) schema += ', ...';
            schema += `)`;

            // FK
            if (table.foreignKeys.length > 0) {
                schema += ` FK:${table.foreignKeys[0]}`;
            }
        }

        // Luego el resto (solo nombres de tablas no core)
        const otherTables = tablesInfo
            .filter(t => !coreTables.includes(t.name))
            .map(t => t.name)
            .slice(0, 15); // Máximo 15 nombres

        if (otherTables.length > 0) {
            schema += `\n\nOtras: ${otherTables.join(', ')}`;
        }

        // Reglas SQL
        schema += `\n\nReglas:
- Usar LIMIT para limitar resultados (máximo 100 registros)
- Solo queries SELECT (lectura), NO INSERT, UPDATE, DELETE
- Usar JOIN cuando sea necesario para relacionar tablas
- Fechas en formato 'YYYY-MM-DD HH:MM:SS'
- Ordenar por campos relevantes con ORDER BY
- Usar alias para mejorar legibilidad: SELECT t.campo AS nombre_campo FROM tabla t
`;

        // Guardar en cache
        cachedSchema = schema;
        lastCacheTime = now;

        return schema;
    } catch (error) {
        console.error('Error generando schema:', error);
        throw error;
    }
}

/**
 * Invalida el cache del schema (útil si cambia la estructura)
 */
export function invalidateSchemaCache(): void {
    cachedSchema = null;
    lastCacheTime = 0;
}
