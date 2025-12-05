import Groq from 'groq-sdk';
import type { IAIProvider, AIResponse, AIModelConfig } from './types.js';

export class GroqProvider implements IAIProvider {
    name = 'groq' as const;
    private client: Groq;
    private config: AIModelConfig;

    constructor(config: AIModelConfig) {
        this.config = {
            model: config.model || 'llama-3.3-70b-versatile',
            temperature: config.temperature ?? 0.1,
            maxTokens: config.maxTokens ?? 200,
            apiKey: config.apiKey
        };

        this.client = new Groq({
            apiKey: this.config.apiKey
        });
    }

    async generateSQL(question: string, dbSchema: string, systemPrompt: string): Promise<AIResponse> {
        try {
            const chatCompletion = await this.client.chat.completions.create({
                messages: [
                    {
                        role: 'system',
                        content: systemPrompt
                    },
                    {
                        role: 'user',
                        content: question
                    }
                ],
                model: this.config.model,
                temperature: this.config.temperature,
                max_tokens: this.config.maxTokens
            });

            const content = chatCompletion.choices[0]?.message?.content?.trim() || '';

            return {
                content,
                model: this.config.model,
                usage: chatCompletion.usage ? {
                    promptTokens: chatCompletion.usage.prompt_tokens,
                    completionTokens: chatCompletion.usage.completion_tokens,
                    totalTokens: chatCompletion.usage.total_tokens
                } : undefined
            };
        } catch (error: any) {
            throw new Error(`Groq API Error: ${error.message}`);
        }
    }

    async testConnection(): Promise<boolean> {
        try {
            const response = await this.client.chat.completions.create({
                messages: [{ role: 'user', content: 'test' }],
                model: this.config.model,
                max_tokens: 5
            });
            return !!response.choices[0]?.message?.content;
        } catch (error) {
            return false;
        }
    }
}
