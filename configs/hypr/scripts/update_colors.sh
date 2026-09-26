#!/bin/bash

# Пути к файлам
KITTY_COLORS="$HOME/.cache/wal/colors-kitty.conf"
FUZZEL_COLORS="$HOME/.config/fuzzel/colors.ini"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"

# Проверяем базу pywal
if [ ! -f "$KITTY_COLORS" ]; then
    exit 1
fi

# Вытаскиваем чистый HEX из кэша
BG=$(awk '/^background/ {print $2}' "$KITTY_COLORS" | tr -d '#\r\n ')
FG=$(awk '/^foreground/ {print $2}' "$KITTY_COLORS" | tr -d '#\r\n ')
COLOR=$(awk '/^color1 / {print $2}' "$KITTY_COLORS" | tr -d '#\r\n ')
SEL=$(awk '/^color8 / {print $2}' "$KITTY_COLORS" | tr -d '#\r\n ')

# Перевод HEX в RGB числа
hex_to_rgb() {
    printf "%d, %d, %d" 0x${1:0:2} 0x${1:2:2} 0x${1:4:2}
}

RGB_BG=$(hex_to_rgb "$BG")
RGB_FG=$(hex_to_rgb "$FG")
RGB_COLOR=$(hex_to_rgb "$COLOR")

# 1. Обновляем Fuzzel (он INI файлы хавает нормально)
mkdir -p "$HOME/.config/fuzzel"
cat <<EOF > "$FUZZEL_COLORS"
[colors]
background=${BG}ff
text=${FG}ff
prompt=${COLOR}ff
input=${FG}ff
match=${COLOR}ff
selection=${SEL}ff
selection-text=${FG}ff
border=${COLOR}ff
EOF

# 2. МОДИФИЦИРУЕМ STYLE.CSS НАПРЯМУЮ ТЕКСТОМ
# Заменяем наши метки на готовые rgba строки прямо внутри файла
sed -i "s|background: .*;|background: rgba(${RGB_BG}, 0.85);|g" "$WAYBAR_STYLE"
sed -i "s|color: W_FG;|color: rgba(${RGB_FG}, 1.0);|g" "$WAYBAR_STYLE"
sed -i "s|color: W_DIMMED;|color: rgba(${RGB_FG}, 0.4);|g" "$WAYBAR_STYLE"
sed -i "s|color: W_ACCENT;|color: rgba(${RGB_COLOR}, 1.0);|g" "$WAYBAR_STYLE"
sed -i "s|border: 1px solid .*;|border: 1px solid rgba(${RGB_COLOR}, 0.2);|g" "$WAYBAR_STYLE"

# Перезапускаем Waybar, чтобы он сразу обновил панель
pkill -USR2 waybar
