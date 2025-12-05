// Script de prueba para verificar la configuración de los modelos de IA
import { AIProviderFactory } from './src/modelos-ia/index.js';

async function testModel(modelName) {
    console.log(`\n🧪 Probando modelo: ${modelName.toUpperCase()}`);
    console.log('─'.repeat(50));

    try {
        const provider = AIProviderFactory.fromEnv(modelName);
        console.log(`✅ Proveedor creado correctamente`);

        const isConnected = await provider.testConnection();
        if (isConnected) {
            console.log(`✅ Conexión exitosa con ${modelName}`);
        } else {
            console.log(`❌ No se pudo conectar con ${modelName}`);
        }
    } catch (error) {
        console.log(`❌ Error: ${error.message}`);
    }
}

async function main() {
    console.log('\n🚀 VERIFICACIÓN DE MODELOS DE IA');
    console.log('='.repeat(50));

    const activeModel = AIProviderFactory.getActiveModel();
    console.log(`\n📌 Modelo activo configurado: ${activeModel.toUpperCase()}`);

    // Probar cada modelo
    await testModel('groq');
    await testModel('claude');
    await testModel('gemini');

    console.log('\n' + '='.repeat(50));
    console.log('\n💡 INSTRUCCIONES:');
    console.log('   - Para cambiar de modelo, edita AI_MODEL en .env.local');
    console.log('   - Configura las API keys de los modelos que quieras usar');
    console.log('   - Valores válidos: groq, claude, gemini\n');
}

main();
