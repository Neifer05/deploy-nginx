FROM nginx:alpine

# Copiamos nuestro index.html a la ruta donde Nginx sirve las páginas web por defecto
COPY index.html /usr/share/nginx/html/index.html

# Exponemos el puerto 80 del contenedor
EXPOSE 80