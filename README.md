# Docker
***
Docker es una plataforma de código abierto que permite automatizar el despliegue de aplicaciones en contenedores. Los contenedores son entornos ligeros y portátiles que incluyen todo lo necesario para que una aplicación funcione (código, bibliotecas, dependencias, etc.), sin necesidad de instalar o configurar directamente en el sistema operativo donde se ejecuta.

A lo largo de este proyecto veremos como funciona docker.

***
## Instalación
La instalación lo puede obtener en la [Documentación Oficial](https://docs.docker.com/engine/installation/).

Para verificar que la instalación se realizó de manera correcta ejecutamos `docker -v` en el terminal
```
   docker -v 
```

## Conceptos Clave:
- **Imagen**: Una imagen de Docker es una plantilla de solo lectura que contiene todo lo necesario para ejecutar una aplicación (código, dependencias, sistema operativo, etc.). Es un archivo de referencia para crear contenedores.
- **Contenedor**: Es una instancia en ejecución de una imagen. Puedes pensar en un contenedor como un "mini servidor" que ejecuta una aplicación de forma aislada del sistema anfitrión.
Dockerfile: Es un archivo de texto que contiene una serie de instrucciones para construir una imagen de Docker. En este archivo defines qué sistema operativo, aplicaciones, librerías y configuraciones necesita tu aplicación.
- **Docker Hub**: Es un repositorio público (o privado) donde puedes subir y descargar imágenes de Docker preconstruidas.
- **docker-compose**: Es una herramienta que permite definir y ejecutar aplicaciones de varios contenedores usando un archivo docker-compose.yml. Es ideal para proyectos con múltiples servicios (por ejemplo, un servidor web, base de datos y caché).

***
## Comandos esenciales de docker

- **Imagenes:**
    Para construir una imagen de docker, usa un Dockerfile en el directorio actual para construir una imagen con un nombre especifico
    ```
        docker build -t <imagen-name>
    ```
    Para mostrar las imagenes disponibles usamos `docker images`
    ```
        docker images
    ```
    Siempre y cuando no tenga contenedores asociados (corriendo o no). Podemos eliminarlas con `rmi <image-name>` 
    ```
        docker rmi <image-name>
    ```

- Ver en tiempo real los **eventos** que lanza docker:
    ```
        docker events
    ```

- **Correr** un contenedor de docker
    ```
        docker run <image-name>
    ```
    Para ejecutar un cen segundo plano agregamos `-d` y si es necesario un puerto mapeado del host del contenedor con `-p`
    ```
        docker run -d -p <port> <imagen-name>
    ```

- **Detener** un contenedor
    ```
        docker stop <container-id>
    ```

- **Mostrar** los contenedores en **ejecución** 
    ```
        docker ps
    ```
    Para poder ver el historial de ejecución y los contenedores actuales creados que estén corriendo o no agregamos `a` al comando anterior
    ```
        docker ps -a
    ```

- **Eliminar** un contenedor
    ```
        Docker rm <container-id>
    ```

- **Descargar** una imagen desde Docker Hub
    ```
        docker pull username/image_name
    ```


***

## Dockerfile

### ¿Que es?
Un Dockerfile es un archivo de texto que contiene una serie de instrucciones que Docker utiliza para crear una imagen. Las instrucciones definen cómo debe construirse el entorno del contenedor, qué software debe incluirse, cómo debe configurarse y qué comandos deben ejecutarse al iniciar el contenedor.

### Estructura básica de un Dockerfile
1. **FROM:** Define la imagen base a partir de la cual se va a construir el contenedor
    ```Dockerfile
        FROM php:8.2-fpm
    ```

2. **RUN:** Ejecuta comandos en la imagen para instalar software o realizar configuraciones
    ```Dockerfile
        RUN apt-get 
    ```

3. **COPY o ADD**: Copia archivos o directorios desde tu maquina local al contenedor
    ```Dockerfile
        COPY . /var/www/html
    ```

4. **WORKDIR:** Establece el directorio de trabajo dentro del contenedor. Todos los comandos posteriores se ejecutaran en este directorio
    ```Dockerfile
        WORKDIR /var/www/html
    ```

5. **CMD o ENTRYPOINT:** Define el comando que se ejcutara cuando se inicie el contenedor. `CMD` puede ser reemplazado si se pasa un comando al ejecutar el contenedor, mientras que `ENTRYPOINT` no

6. **EXPOSE:** Expone un puerto del contenedor para que pueda ser accedido externamente

### Ejemplo de un Dockerfile para una aplicacion PHP:
```Dockerfile
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
```

### Como se utliza un Dockerfile
1. Crea un archivo `Dockerfile` en el directorio raiz de tu proyecto.
2. Luego, desde ese directorio, ejecutas el siguiente comando para crear la imagen de Docker:
    ```bash
        docker build -t <imagen-name> .
    ```
3. Una vez que la imagen esta construida, puedes ejecutar un contenedor basado en esa imagen
    ```bash
        docker run -d -p 9000:9000 <imagen-name>
    ```
4. Podemos ejecutar nuestro archivo `index.php` con el siguiente comando y veremos el contenido del archivo
    ```bash
        docker exec -it <nombre_del_contenedor> php /var/www/html/index.php
    ```

#### Consideración adicional
- **Mount de Volúmenes:** Si deseas editar archivos en tu maquina local y se vean refeljados en el contenedor sin necesidad de recontruir la imagen, puedes usar volúmenes:
    ```bash
        docker run -d -p 9000:9000 -v $(pwd):/var/www/html <image-name>
    ```
    Esto montará el directorio actual (`$pdw`) en `/var/www/hmtl` del contenedor, permitiendo que los cambios se ereflejen en tiempo real