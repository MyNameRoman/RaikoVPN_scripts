#!/bin/bash

LOGFILE="/var/log/cleanup_every_5days.log"
BOT_TOKEN="your_bot_token"
CHAT_ID="your_chat_ID"

send_telegram() {
    local MESSAGE="$1"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$MESSAGE" \
        -d parse_mode="Markdown"
}

# Проверка ошибок
run_cmd() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Running: $*" >> "$LOGFILE"
    "$@" >> "$LOGFILE" 2>&1
    if [ $? -ne 0 ]; then
        ERROR_MSG="❌ *cleanup_every_5days.sh* — ошибка при выполнении:\n\`$*\`"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $*" >> "$LOGFILE"
        send_telegram "$ERROR_MSG"
        exit 1
    fi
}

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting cleanup..." >> "$LOGFILE"

for dir in /tmp /var/tmp; do
    if [ -d "$dir" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning $dir (files older than 1 day)" >> "$LOGFILE"
        find "$dir" -type f -mtime +1 -exec rm -f {} \; >> "$LOGFILE" 2>&1
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Directory $dir does not exist." >> "$LOGFILE"
    fi
done

echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning logs older than 5 days in /var/log" >> "$LOGFILE"
find /var/log -type f -name "*.log" -mtime +5 -exec rm -f {} \; >> "$LOGFILE" 2>&1

if [ -d "/var/lib/snapd/cache" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning Snap cache" >> "$LOGFILE"
    rm -rf /var/lib/snapd/cache/* >> "$LOGFILE" 2>&1
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Snap cache not found" >> "$LOGFILE"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleanup completed successfully. Rebooting..." >> "$LOGFILE"
send_telegram "✅ *cleanup_every_5days.sh* — выполнен успешно. Перезагрузка через пару секунд"
reboot
