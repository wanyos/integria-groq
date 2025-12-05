import { GoogleGenerativeAI } from '@google/generative-ai';
import type { IAIProvider, AIResponse, AIModelConfig } from './types.js';

export class GeminiProvider implements IAIProvider {
    name = 'gemini' as const;
    private client: GoogleGenerativeAI;
    private config: AIModelConfig;

    constructor(config: AIModelConfig) {
        this.config = {
            model: config.model || 'gemini-1.5-flash',
            temperature: config.temperature ?? 0.1,
            maxTokens: config.maxTokens ?? 200,
            apiKey: config.apiKey
        };

        this.client = new GoogleGenerativeAI(this.config.apiKey);
    }

    async generateSQL(question: string, dbSchema: string, systemPrompt: string): Promise<AIResponse> {
        try {
            const model = this.client.getGenerativeModel({
                model: this.config.model,
                generationConfig: {
                    temperature: this.config.temperature,
                    maxOutputTokens: this.config.maxTokens,
                }
            });

            // Gemini usa un prompt combinado
            const fullPrompt = `${systemPrompt}\n\nPregunta del usuario: ${question}`;

            const result = await model.generateContent(fullPrompt);
            const response = result.response;
            const content = response.text();

            // Gemini no proporciona uso de tokens de manera directa en todas las versiones
            return {
                content,
                model: this.config.model,
                usage: response.usageMetadata ? {
                    promptTokens: response.usageMetadata.promptTokenCount || 0,
                    completionTokens: response.usageMetadata.candidatesTokenCount || 0,
                    totalTokens: response.usageMetadata.totalTokenCount || 0
                } : undefined
            };
        } catch (error: any) {
            throw new Error(`Gemini API Error: ${error.message}`);
        }
    }

    async testConnection(): Promise<boolean> {
        try {
            const model = this.client.getGenerativeModel({
                model: this.config.model
            });
            const result = await model.generateContent('test');
            return !!result.response.text();
        } catch (error) {
            return false;
        }
    }
}
