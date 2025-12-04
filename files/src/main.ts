import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const createFile = (fileName: string, data: object) => {
    const filePath = path.join(__dirname, fileName)
    fs.writeFileSync(filePath, JSON.stringify(data, null, 2), 'utf-8')
}

const data = {
    nombre: 'juanjo',
    lastName: 'romero',
    ciudad: 'madrid'
}

createFile('nombres.json', data)