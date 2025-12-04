# Base de Datos MySQL con Docker

Este directorio contiene la configuración y datos para la base de datos MySQL de Integria.

## Archivos

- `01-structure-integria.sql` - Estructura de la base de datos (tablas, índices, etc.)
- `02-integria-data.sql` - Datos de prueba
- `docker-compose.yml` - Configuración del contenedor MySQL

## Requisitos

- Docker instalado y en ejecución
- Puerto 3306 disponible (o modificar el puerto en docker-compose.yml)

## Comandos principales

### 1. Iniciar el contenedor (primera vez)

```bash
cd /Users/wanyos/vue/tutorial/typescript/database
docker compose up -d
```

Esto hará automáticamente:
- Crear el contenedor MySQL
- Crear el volumen persistente para los datos
- Ejecutar `01-structure-integria.sql` (estructura)
- Ejecutar `02-integria-data.sql` (datos)

### 2. Ver logs del contenedor

```bash
docker compose logs -f mysql
```

### 3. Ver estado del contenedor

```bash
docker compose ps
```

### 4. Detener el contenedor

```bash
docker compose down
```

**Nota:** Los datos persisten en el volumen `mysql_data`

### 5. Reiniciar el contenedor

```bash
docker compose restart
```

### 6. Eliminar TODO (contenedor + volumen + datos)

```bash
docker compose down -v
```

⚠️ **CUIDADO:** Esto eliminará todos los datos permanentemente.

## Conectarse a MySQL

### Desde terminal (dentro del contenedor)

```bash
docker exec -it integria-mysql mysql -u integria_user -p
```

Password: `integria_pass`

### Desde terminal (línea de comandos MySQL)

```bash
mysql -h 127.0.0.1 -P 3306 -u integria_user -p integria
```

### Desde tu aplicación (Node.js/TypeScript)

```typescript
const config = {
  host: 'localhost',
  port: 3306,
  database: 'integria',
  user: 'integria_user',
  password: 'integria_pass'
}
```

## Credenciales

- **Root Password:** `root_password`
- **Database:** `integria`
- **User:** `integria_user`
- **Password:** `integria_pass`

## Cargar datos manualmente (si es necesario)

Si necesitas recargar los datos sin recrear el contenedor:

### Opción 1: Cargar estructura y datos (recomendado)

```bash
# Ir al directorio de la base de datos
cd /Users/wanyos/vue/tutorial/typescript/database

# Cargar estructura
docker exec -i integria-mysql mysql -u integria_user -pintegria_pass integria < 01-structure-integria.sql

# Cargar datos (con foreign keys desactivadas temporalmente)
(echo "SET FOREIGN_KEY_CHECKS=0;" && cat 02-integria-data.sql && echo "SET FOREIGN_KEY_CHECKS=1;") | docker exec -i integria-mysql mysql -u integria_user -pintegria_pass integria
```

### Opción 2: Usar usuario root (más simple pero requiere permisos root)

```bash
# Cargar estructura
docker exec -i integria-mysql mysql -u root -proot_password integria < 01-structure-integria.sql

# Cargar datos
docker exec -i integria-mysql mysql -u root -proot_password integria < 02-integria-data.sql
```

### Verificar que los datos se cargaron

```bash
# Ver tablas
docker exec -it integria-mysql mysql -u integria_user -pintegria_pass integria -e "SHOW TABLES;"

# Contar registros en una tabla
docker exec -it integria-mysql mysql -u integria_user -pintegria_pass integria -e "SELECT COUNT(*) FROM emt_localizacion;"
```

## Backup de la base de datos

```bash
# Hacer backup
docker exec integria-mysql mysqldump -u integria_user -pintegria_pass integria > backup_$(date +%Y%m%d_%H%M%S).sql

# Restaurar backup
docker exec -i integria-mysql mysql -u integria_user -pintegria_pass integria < backup_20231204_153000.sql
```

## Solución de problemas

### El contenedor no inicia

```bash
# Ver logs detallados
docker-compose logs mysql

# Verificar que el puerto 3306 no esté en uso
lsof -i :3306
```

### Resetear completamente la base de datos

```bash
# 1. Detener y eliminar todo
docker-compose down -v

# 2. Iniciar de nuevo (cargará los archivos SQL automáticamente)
docker-compose up -d
```

### Acceder como root

```bash
docker exec -it integria-mysql mysql -u root -p
```

Password: `root_password`
