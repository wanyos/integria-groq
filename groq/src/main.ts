import Fastify from 'fastify'
import type { FastifyRequest, FastifyReply } from 'fastify'
import { pool } from './mysql.js'
import Groq from 'groq-sdk';
import { getDatabaseSchema, invalidateSchemaCache } from './schema-generator.js';
import { analyzeDatabase, generateAnalysisReport } from './schema-analyzer.js';

const PORT = 8155

const server = Fastify({ logger: true })

// Inicializar Groq
const groq = new Groq({
    apiKey: process.env.GROQ_API_KEY
});


server.get('/', (request: FastifyRequest, reply: FastifyReply) => {
    reply.status(200).send('hello fastify')
})


server.get('/test-db', async (_request: FastifyRequest, reply: FastifyReply) => {
    try {
        const [rows] = await pool.query('SELECT * FROM tincidencia ORDER BY id_incidencia desc LIMIT 15')
        reply.status(200).send({ success: true, data: rows })
    } catch (error) {
        reply.status(500).send({ success: false, error: 'Database connection failed' })
    }
})

interface QueryRequest {
    question: string;
}

server.post<{ Body: QueryRequest }>('/query', async (request: FastifyRequest<{ Body: QueryRequest }>, reply: FastifyReply) => {
    let sqlQuery = '';
    try {
        const { question } = request.body;

        if (!question) {
            return reply.status(400).send({
                success: false,
                error: 'La pregunta es requerida'
            });
        }

        // 1. Obtener schema dinámicamente
        const dbSchema = await getDatabaseSchema();

        // 2. Usar Groq para generar la query SQL
        const chatCompletion = await groq.chat.completions.create({
            messages: [
                {
                    role: 'system',
                    content: `Eres un experto SQL.

TABLAS DISPONIBLES:
${dbSchema}

⚠️ ADVERTENCIA: Los nombres de tabla son EXACTOS. NO los traduzcas ni modifiques.
- ✅ CORRECTO: tincidencia, tusuario, tinventory, tgrupo
- ❌ INCORRECTO: tincident, tuser, tincident_track, tincident_field_data

REGLAS:
1. Usa EXACTAMENTE los nombres de tabla de arriba
2. Responde SOLO con SQL puro, sin texto adicional
3. Si necesitas más columnas, usa SELECT * FROM tabla
4. Usa LIMIT (máximo 100)

EJEMPLOS:
SELECT * FROM tincidencia ORDER BY id_incidencia DESC LIMIT 10
SELECT titulo, inicio FROM tincidencia WHERE id_usuario = 5
SELECT i.titulo, u.nombre_real FROM tincidencia i JOIN tusuario u ON i.id_usuario = u.id_usuario LIMIT 20`
                },
                {
                    role: 'user',
                    content: question
                }
            ],
            model: 'llama-3.3-70b-versatile',
            temperature: 0.1,
            max_tokens: 200
        });

        let rawResponse = chatCompletion.choices[0]?.message?.content?.trim() || '';

        if (!rawResponse) {
            return reply.status(500).send({
                success: false,
                error: 'No se pudo generar la query SQL'
            });
        }

        // Limpiar la respuesta: remover markdown code blocks si existen
        sqlQuery = rawResponse
            .replace(/```sql\n?/g, '')
            .replace(/```\n?/g, '')
            .replace(/^\s*sql\s*/i, '')
            .trim();

        // Validación básica de seguridad
        const forbiddenKeywords = ['INSERT', 'UPDATE', 'DELETE', 'DROP', 'TRUNCATE', 'ALTER', 'CREATE'];
        const upperQuery = sqlQuery.toUpperCase();

        for (const keyword of forbiddenKeywords) {
            if (upperQuery.includes(keyword)) {
                return reply.status(403).send({
                    success: false,
                    error: `Operación no permitida: ${keyword}`
                });
            }
        }

        // 2. Ejecutar la query en la base de datos
        const [rows] = await pool.query(sqlQuery);

        // 3. Devolver resultados
        reply.status(200).send({
            success: true,
            question,
            sql: sqlQuery,
            data: rows,
            count: Array.isArray(rows) ? rows.length : 0
        });

    } catch (error: any) {
        server.log.error(error);

        // Si el error es de tabla inexistente, dar sugerencia
        let errorMessage = error.message || 'Error al procesar la consulta';

        if (error.message?.includes("doesn't exist")) {
            errorMessage += '\nSugerencia: Verifica que los nombres de tabla sean exactos. Usa GET /schema para ver las tablas disponibles.';
        }

        reply.status(500).send({
            success: false,
            error: errorMessage,
            sql: sqlQuery
        });
    }
})

// Endpoint para ver el schema de la base de datos
server.get('/schema', async (_request: FastifyRequest, reply: FastifyReply) => {
    try {
        const schema = await getDatabaseSchema();
        reply.status(200).send({
            success: true,
            schema
        });
    } catch (error: any) {
        server.log.error(error);
        reply.status(500).send({
            success: false,
            error: error.message || 'Error al obtener el schema'
        });
    }
})

// Endpoint para refrescar el cache del schema
server.post('/schema/refresh', async (_request: FastifyRequest, reply: FastifyReply) => {
    try {
        invalidateSchemaCache();
        const schema = await getDatabaseSchema();
        reply.status(200).send({
            success: true,
            message: 'Schema actualizado correctamente',
            schema
        });
    } catch (error: any) {
        server.log.error(error);
        reply.status(500).send({
            success: false,
            error: error.message || 'Error al refrescar el schema'
        });
    }
})

// Endpoint para analizar la base de datos
server.get('/analyze', async (_request: FastifyRequest, reply: FastifyReply) => {
    try {
        const { coreTables, stats } = await analyzeDatabase();
        const report = generateAnalysisReport(stats);

        reply.status(200).send({
            success: true,
            coreTables,
            totalTables: stats.length,
            tablesWithData: stats.filter(s => s.hasData).length,
            emptyTables: stats.filter(s => !s.hasData).length,
            report,
            stats: stats.slice(0, 20) // Top 20 tablas
        });
    } catch (error: any) {
        server.log.error(error);
        reply.status(500).send({
            success: false,
            error: error.message || 'Error al analizar la base de datos'
        });
    }
})

const startServer = () => {

    server.listen({ port: PORT })
    server.log.info(`server is running in port: ${PORT}`)
}

startServer()