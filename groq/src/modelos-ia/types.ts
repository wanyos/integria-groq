// Tipos compartidos para todos los modelos de IA

export type AIModel = 'groq' | 'claude' | 'gemini';

export interface AIMessage {
    role: 'system' | 'user' | 'assistant';
    content: string;
}

export interface AIResponse {
    content: string;
    model: string;
    usage?: {
        promptTokens: number;
        completionTokens: number;
        totalTokens: number;
    };
}

export interface AIModelConfig {
    apiKey: string;
    model: string;
    temperature?: number;
    maxTokens?: number;
}

export interface IAIProvider {
    name: AIModel;
    generateSQL(question: string, dbSchema: string, systemPrompt: string): Promise<AIResponse>;
    testConnection(): Promise<boolean>;
}
