#!/bin/bash
set -e

echo "🔄 Iniciando aplicación Laravel..."

# Esperar conexión a la base de datos
echo "⏳ Esperando conexión a la base de datos..."
sleep 15

# Ejecutar migraciones
echo "🗄️ Ejecutando migraciones..."
php artisan migrate --force

# Ejecutar seeders (solo si no fallan)
echo "🌱 Ejecutando seeders..."
php artisan db:seed --force || echo "⚠️ Seeders fallaron, continuando sin datos de prueba..."

# Cache de configuración
echo "⚡ Optimizando aplicación..."
php artisan config:cache
php artisan route:cache || echo "Route cache falló"
php artisan view:cache || echo "View cache falló"

echo "✅ Aplicación lista, iniciando servidor..."

# Iniciar Apache
exec apache2-foreground