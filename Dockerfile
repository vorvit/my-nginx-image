# Используем официальный образ Nginx
FROM nginx:latest

# Устанавливаем обновления и необходимые пакеты, включая nginx
RUN apt-get update && \
apt-get install -y uuid-runtime grep sed gawk && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# Копируем HTML файл и скрипт
COPY index.html /usr/share/nginx/html/index.html
COPY disk_fill.sh /usr/local/bin/disk_fill.sh

# Делаем скрипт исполняемым
RUN chmod +x /usr/local/bin/disk_fill.sh

# Определяем команду запуска
CMD ["/bin/bash", "-c", "/usr/local/bin/disk_fill.sh & nginx -g 'daemon off;'"]

# Используем официальный образ Ubuntu
# FROM ubuntu:latest

# # Устанавливаем обновления и необходимые пакеты, включая nginx
# RUN apt-get update && \
# apt-get install -y uuid-runtime grep sed gawk && \
# apt-get clean && \
# rm -rf /var/lib/apt/lists/*

# # Копируем HTML файл и скрипт
# COPY index.html /var/www/html/index.html
# COPY disk_fill.sh /usr/local/bin/disk_fill.sh

# # Делаем скрипт исполняемым
# RUN chmod +x /usr/local/bin/disk_fill.sh

# # Открываем порт 80 для nginx
# EXPOSE 80

# # Определяем команду запуска
# CMD ["/bin/bash", "-c", "/usr/local/bin/disk_fill.sh & nginx -g 'daemon off;'"]