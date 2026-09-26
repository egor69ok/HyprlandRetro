#!/bin/bash
DIR="$HOME/Pictures/Wallpaper"
# Находим картинки и выбираем одну случайную
RANDOM_PIC=$(find "$DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

# Если нашли картинку — ставим её
if [ -n "$RANDOM_PIC" ]; then
    awww img "$RANDOM_PIC" --transition-type center
fi

if [ -n "$RANDOM_PIC" ]; then
    wal -i "$RANDOM_PIC"

    # ВОТ СЮДА ДОБАВЛЯЕМ ВЫЗОВ НАШЕГО ПАРСЕРА:
    ~/.config/hypr/scripts/update_colors.sh

    awww img "$RANDOM_PIC" --transition-type center
fi

# #!/bin/bash

# # Папка с обоями
# DIR="$HOME/Pictures/Wallpaper"

# # Находим картинки и выбираем одну случайную
# RANDOM_PIC=$(find "$DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

# # Если нашли картинку — запускаем всю цепочку обновлений
# if [ -n "$RANDOM_PIC" ]; then
#     # 1. Генерируем новую цветовую палитру под картинку
#     wal -i "$RANDOM_PIC"

#     # 2. Запускаем наш парсер, чтобы перевести цвета для Fuzzel и Waybar
#     ~/.config/hypr/scripts/update_colors.sh

#     # 3. Проверяем демона awww и ставим обои на рабочий стол с анимацией
#     if ! pgrep -x "awww-daemon" > /dev/null; then
#         awww-daemon &
#         sleep 0.2
#     fi
#     awww img "$RANDOM_PIC" --transition-type center
# fi
