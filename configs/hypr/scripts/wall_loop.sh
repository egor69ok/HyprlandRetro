#!/bin/bash
# Запускаем демон swww, если он еще не запущен
swww-daemon &
sleep 1 # Даем секунду на запуск

while true; do
    # Вызываем твой основной скрипт смены обоев
    ~/.config/hypr/scripts/wall.sh
    sleep 900
done
