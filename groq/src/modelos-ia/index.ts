import { GroqProvider } from './groq.js';
import { ClaudeProvider } from './claude.js';
import { GeminiProvider } from './gemini.js';
import type { IAIProvider, AIModel, AIModelConfig } from './types.js';

/**
 * Factory para crear instancias de proveedores de IA
 */
export class AIProviderFactory {
    /**
     * Crea un proveedor de IA según el modelo especificado
     * @param modelType - Tipo de modelo: 'groq', 'claude', o 'gemini'
     * @param config - Configuración del modelo
     * @returns Instancia del proveedor de IA
     */
    static create(modelType: AIModel, config: AIModelConfig): IAIProvider {
        switch (modelType) {
            case 'groq':
                return new GroqProvider(config);
            case 'claude':
                return new ClaudeProvider(config);
            case 'gemini':
                return new GeminiProvider(config);
            default:
                throw new Error(`Modelo de IA no soportado: ${modelType}`);
        }
    }

    /**
     * Crea un proveedor desde variables de entorno
     * @param modelType - Tipo de modelo
     * @returns Instancia del proveedor de IA
     */
    static fromEnv(modelType: AIModel): IAIProvider {
        const apiKeyMap: Record<AIModel, string> = {
            groq: process.env.GROQ_API_KEY || '',
            claude: process.env.ANTHROPIC_API_KEY || '',
            gemini: process.env.GEMINI_API_KEY || ''
        };

        const apiKey = apiKeyMap[modelType];
        if (!apiKey) {
            throw new Error(`API Key no configurada para ${modelType}. Verifica las variables de entorno.`);
        }

        return AIProviderFactory.create(modelType, { apiKey, model: '' });
    }

    /**
     * Obtiene el modelo de IA activo desde variable de entorno
     * Por defecto usa 'groq'
     */
    static getActiveModel(): AIModel {
        const model = (process.env.AI_MODEL || 'groq').toLowerCase();
        if (model !== 'groq' && model !== 'claude' && model !== 'gemini') {
            console.warn(`Modelo "${model}" no reconocido, usando "groq" por defecto`);
            return 'groq';
        }
        return model as AIModel;
    }
}

// Exportar tipos y clases
export * from './types.js';
export { GroqProvider } from './groq.js';
export { ClaudeProvider } from './claude.js';
export { GeminiProvider } from './gemini.js';
