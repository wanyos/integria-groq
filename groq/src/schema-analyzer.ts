import { pool } from './mysql.js';

interface TableStats {
    name: string;
    rowCount: number;
    hasData: boolean;
    isCore: boolean;
}

/**
 * Analiza las tablas de la base de datos para identificar las más importantes
 */
export async function analyzeDatabase(): Promise<{
    coreTables: string[];
    stats: TableStats[];
}> {
    try {
        // 1. Obtener todas las tablas
        const [tables] = await pool.query<any[]>('SHOW TABLES');
        const tableNames = tables.map((row: any) => Object.values(row)[0] as string);

        // 2. Palabras clave que identifican tablas principales
        const coreKeywords = [
            'incidencia', 'ticket', 'usuario', 'user', 'grupo', 'group',
            'inventario', 'inventory', 'activo', 'asset', 'equipo',
            'attachment', 'adjunto', 'comentario', 'comment', 'nota'
        ];

        // Sufijos que indican tablas auxiliares (menor prioridad)
        const auxiliaryPatterns = ['_field_data', '_track', '_stats', '_acl', '_sla', '_graph'];

        const stats: TableStats[] = [];

        // 3. Para cada tabla, contar registros y evaluar importancia
        for (const tableName of tableNames) {
            try {
                // Contar registros
                const [countResult] = await pool.query(
                    `SELECT COUNT(*) as count FROM ${tableName}`
                ) as [any[], any];

                const rowCount = countResult[0]?.count || 0;
                const hasData = rowCount > 0;

                // Determinar si es tabla core basándose en nombre y datos
                const matchesKeyword = coreKeywords.some(keyword =>
                    tableName.toLowerCase().includes(keyword)
                );

                // Determinar si es tabla auxiliar
                const isAuxiliary = auxiliaryPatterns.some(pattern =>
                    tableName.toLowerCase().includes(pattern)
                );

                // Es core si:
                // - Coincide con keywords Y tiene datos Y NO es auxiliar
                // - O tiene más de 100 registros Y NO es auxiliar
                const isCore = ((matchesKeyword && hasData) || rowCount > 100) && !isAuxiliary;

                stats.push({
                    name: tableName,
                    rowCount,
                    hasData,
                    isCore
                });
            } catch (error) {
                console.error(`Error analyzing table ${tableName}:`, error);
            }
        }

        // 4. Ordenar por importancia con prioridad para tablas principales
        stats.sort((a, b) => {
            const aIsAux = auxiliaryPatterns.some(p => a.name.toLowerCase().includes(p));
            const bIsAux = auxiliaryPatterns.some(p => b.name.toLowerCase().includes(p));

            // Máxima prioridad para tablas principales específicas
            const mainTables = ['tincidencia', 'tusuario', 'tinventory', 'tgrupo'];
            const aIsMain = mainTables.includes(a.name);
            const bIsMain = mainTables.includes(b.name);

            if (aIsMain && !bIsMain) return -1;
            if (!aIsMain && bIsMain) return 1;

            // Core vs no-core
            if (a.isCore && !b.isCore) return -1;
            if (!a.isCore && b.isCore) return 1;

            // Entre core tables, preferir no auxiliares
            if (a.isCore && b.isCore) {
                if (!aIsAux && bIsAux) return -1;
                if (aIsAux && !bIsAux) return 1;
            }

            return b.rowCount - a.rowCount;
        });

        // 5. Extraer nombres de tablas core
        const coreTables = stats
            .filter(s => s.isCore)
            .map(s => s.name);

        return { coreTables, stats };
    } catch (error) {
        console.error('Error analyzing database:', error);
        throw error;
    }
}

/**
 * Genera un reporte legible del análisis
 */
export function generateAnalysisReport(stats: TableStats[]): string {
    let report = '# Análisis de la Base de Datos\n\n';

    // Tablas principales
    const coreTables = stats.filter(s => s.isCore);
    report += `## Tablas Principales (${coreTables.length}):\n`;
    for (const table of coreTables) {
        report += `- ${table.name}: ${table.rowCount.toLocaleString()} registros\n`;
    }

    // Tablas con datos pero no core
    const otherTablesWithData = stats.filter(s => !s.isCore && s.hasData);
    if (otherTablesWithData.length > 0) {
        report += `\n## Otras Tablas con Datos (${otherTablesWithData.length}):\n`;
        for (const table of otherTablesWithData.slice(0, 10)) {
            report += `- ${table.name}: ${table.rowCount.toLocaleString()} registros\n`;
        }
        if (otherTablesWithData.length > 10) {
            report += `- ... y ${otherTablesWithData.length - 10} más\n`;
        }
    }

    // Tablas vacías
    const emptyTables = stats.filter(s => !s.hasData);
    if (emptyTables.length > 0) {
        report += `\n## Tablas Vacías (${emptyTables.length}):\n`;
        report += `${emptyTables.map(t => t.name).join(', ')}\n`;
    }

    return report;
}
