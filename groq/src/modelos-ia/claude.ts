import Anthropic from '@anthropic-ai/sdk';
import type { IAIProvider, AIResponse, AIModelConfig } from './types.js';

export class ClaudeProvider implements IAIProvider {
    name = 'claude' as const;
    private client: Anthropic;
    private config: AIModelConfig;

    constructor(config: AIModelConfig) {
        this.config = {
            model: config.model || 'claude-3-5-sonnet-20241022',
            temperature: config.temperature ?? 0.1,
            maxTokens: config.maxTokens ?? 200,
            apiKey: config.apiKey
        };

        this.client = new Anthropic({
            apiKey: this.config.apiKey
        });
    }

    async generateSQL(question: string, dbSchema: string, systemPrompt: string): Promise<AIResponse> {
        try {
            const message = await this.client.messages.create({
                model: this.config.model,
                max_tokens: this.config.maxTokens!,
                temperature: this.config.temperature,
                system: systemPrompt,
                messages: [
                    {
                        role: 'user',
                        content: question
                    }
                ]
            });

            const content = message.content[0]?.type === 'text'
                ? message.content[0].text
                : '';

            return {
                content,
                model: this.config.model,
                usage: {
                    promptTokens: message.usage.input_tokens,
                    completionTokens: message.usage.output_tokens,
                    totalTokens: message.usage.input_tokens + message.usage.output_tokens
                }
            };
        } catch (error: any) {
            throw new Error(`Claude API Error: ${error.message}`);
        }
    }

    async testConnection(): Promise<boolean> {
        try {
            const response = await this.client.messages.create({
                model: this.config.model,
                max_tokens: 5,
                messages: [{ role: 'user', content: 'test' }]
            });
            return response.content.length > 0;
        } catch (error) {
            return false;
        }
    }
}
