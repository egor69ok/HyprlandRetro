#!/bin/bash

# =====================================================================
# Скрипт автоустановки Retro (Hyprland) для FIREBAT U6C
# Запускать от имени ОБЫЧНОГО пользователя! (НЕ через sudo)
# =====================================================================

set -e # Прерывать работу при ошибках

# Запоминаем путь к папке, в которой лежит этот скрипт
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "=== [1/6] Синхронизация репозиториев и установка базы ==="
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git wget curl pipewire wireplumber

echo "=== [2/6] Установка AUR-помощника (yay) ==="
if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR"
else
    echo "AUR-помощник (yay) уже установлен."
fi

echo "=== [3/6] Установка графического окружения ==="
yay -S --needed --noconfirm \
    hyprland \
    waybar \
    awww-git \
    fuzzel \
    kitty \
    hyprpicker \
    grim \
    slurp \
    wl-clipboard \
    wf-recorder \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    imv \
    mpv

echo "=== [4/6] Установка CLI/TUI утилит, Браузера и Zed IDE ==="
yay -S --needed --noconfirm \
    zen-browser-bin \
    zed \
    wlctl-bin \
    yazi \
    bluetui \
    pulsemixer \
    brightnessctl \
    grimblast-git

echo "=== [5/6] Системные службы и Шрифты ==="
yay -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd \
    otf-font-awesome \
    noto-fonts-cjk \
    noto-fonts-emoji \
    bluez \
    bluez-utils \
    networkmanager

# Включаем сетевые службы
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now NetworkManager.service

echo "=== [6/6] Создание папок и деплой твоих конфигов ==="
# Создаем папки для скриншотов и видео на всякий случай
mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Videos

# Проверяем, существует ли папка configs рядом со скриптом
if [ -d "$SCRIPT_DIR/configs" ]; then
    echo "Найдена папка с конфигурациями. Копирую в ~/.config/..."

    # Создаем целевую директорию ~/.config, если её нет
    mkdir -p ~/.config

    # Копируем содержимое папки configs внутрь ~/.config без перезаписи всей директории целиком
    cp -r "$SCRIPT_DIR/configs/"* ~/.config/

    # Автоматически делаем все твои скрипты исполняемыми
    if [ -d ~/.config/hypr/scripts ]; then
        chmod +x ~/.config/hypr/scripts/*.sh
        echo "Права на запуск для скриптов смены обоев и цветов успешно выданы!"
    fi
else
    echo "⚠️ Внимание: Папка '$SCRIPT_DIR/configs' не найдена! Конфиги не скопированы."
fi

echo "=== Настройка ассоциаций файлов ==="
if command -v xdg-mime &> /dev/null; then
    # Ассоциации для картинок
    xdg-mime default imv-dir.desktop image/jpeg image/png image/gif image/webp image/bmp image/svg+xml
    echo "imv-dir успешно назначен для картинок."

    # Ассоциации для видео и аудио (mpv)
    xdg-mime default mpv.desktop video/mp4 video/x-matroska video/x-msvideo video/quicktime video/webm audio/mpeg audio/ogg audio/aac audio/flac
    echo "mpv успешно назначен для видео и аудио по умолчанию."
else
    echo "⚠️ xdg-utils не установлены, не удалось задать ассоциации файлов."
fi


echo "====================================================================="
echo " Сборка Retro успешно установлена и настроена! "
echo " Можно перезагружаться и заходить в Hyprland. "
echo "====================================================================="
echo "=================================end=================================="
