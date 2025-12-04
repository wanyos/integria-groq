import Fastify from 'fastify'
import type { FastifyRequest, FastifyReply } from 'fastify'
import cors from '@fastify/cors'
import { pool } from './mysql.js'
import Groq from 'groq-sdk';
import { getDatabaseSchema, invalidateSchemaCache } from './schema-generator.js';
import { analyzeDatabase, generateAnalysisReport } from './schema-analyzer.js';

const PORT = 8155

const server = Fastify({ logger: true })

await server.register(cors, {
    origin: 'http://localhost:5173',
    methods: ['GET', 'POST'],
    credentials: true
})

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
                    content: `Eres un experto SQL especializado en la base de datos de Integria IMS.

TABLAS DISPONIBLES:
${dbSchema}

⚠️ NOMBRES DE TABLA EXACTOS - NO los traduzcas:
- ✅ CORRECTO: tincidencia, tusuario, tinventory, tgrupo, tobject_type_setup
- ❌ INCORRECTO: tincident, tuser, inventory, object_type

📋 GUÍA DE CONSULTAS POR TIPO:

INCIDENCIAS:
- Tabla principal: tincidencia
- Campos clave: id_incidencia, titulo, descripcion, inicio, id_usuario, id_grupo
- Ejemplo: SELECT * FROM tincidencia ORDER BY id_incidencia DESC LIMIT 10

INVENTARIO:
- Tabla principal: tinventory
- Campos clave: id, id_object_type, name, description
- El campo 'name' contiene códigos (ej: FUENTE-0001), NO nombres descriptivos
- Para buscar por tipo usa 'description' con LIKE, NO 'name'
- Para ordenadores: WHERE description LIKE '%ordenador%' OR description LIKE '%computer%' OR description LIKE '%PC%'
- Para portátiles: WHERE description LIKE '%portatil%' OR description LIKE '%laptop%'
- Para teléfonos: WHERE description LIKE '%telefono%' OR description LIKE '%phone%' OR description LIKE '%movil%'
- Para total general: SELECT COUNT(*) AS total FROM tinventory
- Para ver tipos disponibles: SELECT id_object_type, COUNT(*) FROM tinventory GROUP BY id_object_type
- Ejemplo: SELECT COUNT(*) AS total FROM tinventory WHERE description LIKE '%portatil%'

USUARIOS:
- Tabla principal: tusuario
- Campos clave: id_usuario, nombre_real, id_usuario

REGLAS IMPORTANTES:
1. Usa EXACTAMENTE los nombres de tabla del schema
2. Responde SOLO con SQL, sin explicaciones
3. Para inventario, usa tinventory con id_object_type, NO busques en otras tablas
4. SIEMPRE usa LIMIT (máximo 100)
5. Para contar cosas, usa COUNT(*) AS nombre_descriptivo

EJEMPLOS CORRECTOS:
- Incidencias: SELECT * FROM tincidencia ORDER BY id_incidencia DESC LIMIT 10
- Inventario total: SELECT COUNT(*) AS total_inventario FROM tinventory LIMIT 1
- Por tipo: SELECT COUNT(*) AS total FROM tinventory WHERE id_object_type = 1 LIMIT 1
- Con nombres: SELECT name, description FROM tinventory LIMIT 20`
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

// Endpoint para obtener tipos de objetos del inventario
server.get('/inventory-types', async (_request: FastifyRequest, reply: FastifyReply) => {
    try {
        const [types] = await pool.query(`
            SELECT id, name, description
            FROM tobject_type_setup
            ORDER BY id
        `);

        const [counts] = await pool.query(`
            SELECT id_object_type, COUNT(*) as count
            FROM tinventory
            GROUP BY id_object_type
        `);

        reply.status(200).send({
            success: true,
            types,
            counts
        });
    } catch (error: any) {
        server.log.error(error);
        reply.status(500).send({
            success: false,
            error: error.message || 'Error al obtener tipos de inventario'
        });
    }
})

const startServer = () => {

    server.listen({ port: PORT })
    server.log.info(`server is running in port: ${PORT}`)
}

startServer()