#!/bin/bash

show_help() {
    echo "Используем: userhome [-f файл] имя_пользователя"
    echo "  -f Файл   можно другой файл вместо /etc/passwd"
    echo "  Ммя_пользователя   если не писать то возьмет текущего"
    echo "  --help     Это подсказки"
    echo "  --usage    Обо всём кратко"
}

if [ "$1" = "--help" ] || [ "$1" = "--usage" ]; then
    show_help
    exit 0
fi

PASSWD_FILE="/etc/passwd"
USERNAME=""

while [ $# -gt 0 ]; do
    case "$1" in
        -f)
            if [ -z "$2" ]; then
                echo "Надо писать файл после -f" >&2
                show_help
                exit 1
            fi
            PASSWD_FILE="$2"
            shift 2
            ;;
        *)
            if [ -z "$USERNAME" ]; then
                USERNAME="$1"
                shift
            else
                echo "Лишние аргументы" >&2
                show_help
                exit 1
            fi
            ;;
    esac
done

if [ -z "$USERNAME" ]; then
    USERNAME=$(whoami)
fi

if [ ! -f "$PASSWD_FILE" ]; then
    echo "Файл '$PASSWD_FILE' не найден" >&2
    exit 2
fi

USER_LINE=$(grep "^$USERNAME:" "$PASSWD_FILE")

if [ -z "$USER_LINE" ]; then
    echo "Пользователь '$USERNAME' не найден" >&2
    exit 1
fi

HOME_DIR=$(echo "$USER_LINE" | cut -d: -f6)
echo "$HOME_DIR"
exit 0

