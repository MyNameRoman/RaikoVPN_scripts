#!/bin/bash

LOGFILE="/var/log/xui_update.log"
BOT_TOKEN="your_bot_token"
CHAT_ID="your_chat_ID"

send_telegram() {
    local MESSAGE="$1"
    # Экранируем спецсимволы Markdown для безопасности
    local ESCAPED_MESSAGE=$(echo "$MESSAGE" | sed -e 's/_/\\_/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/`/\\`/g')
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$ESCAPED_MESSAGE" \
        -d parse_mode="Markdown" > /dev/null
}

format_duration() {
    local D=$1
    if (( D >= 60 )); then
        echo "$((D / 60))m $((D % 60))s"
    else
        echo "${D}s"
    fi
}

run_cmd() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Running: $*" >> "$LOGFILE"
    "$@" >> "$LOGFILE" 2>&1
    if [ $? -ne 0 ]; then
        ERROR_MSG="❌ *xui_update.sh* — ошибка при выполнении команды:\n\`$*\`"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $*" >> "$LOGFILE"
        send_telegram "$ERROR_MSG"
        exit 1
    fi
}

START_TIME=$(date +%s)
START_HUMAN=$(date '+%Y-%m-%d %H:%M:%S')

echo "-----------------------------" >> "$LOGFILE"
echo "$START_HUMAN - Запуск обновления геофайлов XUI" >> "$LOGFILE"

# Выполняем команды x-ui через run_cmd, чтобы логировать и отлавливать ошибки
run_cmd bash -c "x-ui <<EOF
24
3
0
EOF
"

END_TIME=$(date +%s)
DIFF=$((END_TIME - START_TIME))
TIME_STR=$(format_duration $DIFF)

echo "$(date '+%Y-%m-%d %H:%M:%S') - Геофайлы обновлены успешно ✅" >> "$LOGFILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Успешное завершение" >> "$LOGFILE"
echo "Время выполнения: $TIME_STR" >> "$LOGFILE"

MSG="✅ Геофайлы XUI успешно обновлены на сервере *$(hostname)* в $START_HUMAN.
Время выполнения: $TIME_STR

*xui_update.sh* — успешно выполнен!"

send_telegram "$MSG"
