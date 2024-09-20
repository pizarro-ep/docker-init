# Utilizar la imagen oficial de PHP con PHP-FPM
FROM php:8.2-fpm

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /var/www/html

# Copiar los archivos de tu proyecto en el contenedor
COPY . .

# Exponer el puerto 9000, usado por PHP-FPM
EXPOSE 9000

# Comando por defecto para ejecutar PHP-FPM
CMD ["php-fpm"]
