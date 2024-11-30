#!/bin/bash

# Конфигурация
REMOTE_USER="username"
REMOTE_HOST="localhost"
DISK_PARTITION="./disk_fill"  # уточните раздел, за которым хотите следить
THRESHOLD=84  # порог в процентах
LOGFILE="./disk_monitor.log"
EMAIL="vorvit@bk.ru"
CONTAINER_NAME="my-nginx-container"  # Укажите имя или ID контейнера, в котором запущен Nginx

check_disk_space() {
    # Получение процента используемого пространства внутри контейнера
    USED_SPACE=$(docker exec ${CONTAINER_NAME} df -h | grep "${DISK_PARTITION}" | awk '{print $5}' | sed 's/%//')
    USED_SPACE=$(df / | grep '/' | awk '{print $5}' | tr -d '%')
    # Логирование
    echo "$(date): Checked disk space in container ${CONTAINER_NAME}. Used: ${USED_SPACE}%" >> ${LOGFILE}
    echo "$(date): Checked disk space in container ${CONTAINER_NAME}. Used: ${USED_SPACE}%"

    # Проверка с заданным порогом
    if [ "$USED_SPACE" -ge "$THRESHOLD" ]; then
        send_notification $USED_SPACE
        exit  # завершение скрипта
    fi
}

send_notification() {
    local used_space=$1
    SUBJECT="Disk Space Alert on ${CONTAINER_NAME}"
    MESSAGE="Alert: Remaining disk space on ${DISK_PARTITION} is below ${THRESHOLD}%.\nCurrent usage is ${used_space}%."

    echo -e "$MESSAGE" | mail -s "$SUBJECT" "$EMAIL"

    echo "$(date): Sent notification. Used: ${used_space}%" >> ${LOGFILE}
}

# Бесконечный цикл
while true; do
    check_disk_space
    sleep 3  # задержка в 3 секунды (или любое другое значение)
done