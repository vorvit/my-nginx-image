# Мониторинг свободного места на сервере и отправка уведомлений
## Задание
● Реализуйте скрипт, который подключается к удалённому серверу и
проверяет свободное место на диске. Если свободное место меньше
заданного порога, скрипт отправляет уведомление по электронной почте<br>
Требование<br>
● Удаленная проверка свободного места на диске<br>
● Сравнение с заданным порогом<br>
● Логирование всех операций<br>
● Отправка отчета по электронной почте о завершении синхронизации<br>
## Решение
Я написал **dockerfile** для создания образа с сервером **nginx** в контейнере которого, в момент его запуска, начинает работать скрипт **disk_fill.sh**, который создает файлы и сохраняет их в директории **./disk_fill** контейнера. До момента занятия 30% свободной памяти. В процессе своей работы этот скрипт выводит данные по адресу: **localhost:8080/disk_fill_status.html**<br>
При запущенном в работу контейнере необходимо запустить на выполнение основной скрипт **script.sh**, который подключится к контейнеру и начнёт проверку (сохраняя данные в **log-файл**) оставшегося свободного места в цикле, который закончится при достижении порогового значения и отправит письмо с предупреждением на указанную в скрипте почту.<br>
Для тестирования необходимо клонировать репозиторий.<br>
```bash
# И запустить в BUSH команды для сборки образа и его запуска:
docker build -t my-nginx-image .
docker run -d -p 8080:80 --name my-nginx-container my-nginx-image
./script.sh
```
Должны отработать оба скрипта, остановится, создать файл с логами **./disk_monitor.log** и отправить в конце письмо на адрес, указанный в файле **script.sh**.
Для остановки и удаления созданного контейнера и образа и очистки можно запустить следующие команды:
```bash
docker rm -f my-nginx-container
docker rmi my-nginx-image
```
