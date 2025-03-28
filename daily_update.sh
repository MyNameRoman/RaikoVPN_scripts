#!/bin/bash

LOGFILE="/var/log/daily_update.log"
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

run_cmd() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Running: $*" >> "$LOGFILE"
    "$@" >> "$LOGFILE" 2>&1
    if [ $? -ne 0 ]; then
        ERROR_MSG="❌ *daily_update.sh* — ошибка при выполнении команды:\n\`$*\`"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $*" >> "$LOGFILE"
        send_telegram "$ERROR_MSG"
        exit 1
    fi
}

START_TIME=$(date +%s)
START_HUMAN=$(date '+%Y-%m-%d %H:%M:%S')

echo "$START_HUMAN - Starting daily update..." >> "$LOGFILE"

run_cmd apt-get update -y
run_cmd apt-get upgrade -y
run_cmd apt-get dist-upgrade -y
run_cmd apt-get autoclean -y
run_cmd apt-get autoremove -y

END_TIME=$(date +%s)
DIFF=$((END_TIME - START_TIME))

if [ $DIFF -ge 60 ]; then
    MINUTES=$((DIFF / 60))
    SECONDS=$((DIFF % 60))
    TIME_STR="${MINUTES}m ${SECONDS}s"
else
    TIME_STR="${DIFF}s"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Daily update completed in $TIME_STR." >> "$LOGFILE"

MSG="daily_update report for RaikoVPN:
Начало: $START_HUMAN
Время выполнения: $TIME_STR

✅ *daily_update.sh* — успешно выполнен!"

send_telegram "$MSG"
