#!/bin/bash

LOG_FILE="/var/log/rkhunter-weekly.log"
BOT_TOKEN="your_bot_token"
CHAT_ID="your_chat_ID"


send_telegram() {
    local MESSAGE="$1"
    curl --max-time 10 -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$MESSAGE" > /dev/null
}

start_time=$(date +%s)
start_time_human=$(date '+%Y-%m-%d %H:%M:%S')

echo "===== $start_time_human =====" > "$LOG_FILE"
echo "[INFO] Запуск rkhunter в $start_time_human" >> "$LOG_FILE"

# Обновление базы rkhunter
echo "[INFO] Обновляем базу данных..." >> "$LOG_FILE"
/usr/bin/rkhunter --update >> "$LOG_FILE" 2>&1

# Проверка
echo "[INFO] Запуск сканирования..." >> "$LOG_FILE"
/usr/bin/rkhunter --check --skip-keypress --report-warnings-only >> "$LOG_FILE" 2>&1

end_time=$(date +%s)
duration=$((end_time - start_time))

# Форматируем время выполнения
if (( duration > 60 )); then
    minutes=$((duration / 60))
    seconds=$((duration % 60))
    duration_str="${minutes}m ${seconds}s"
else
    duration_str="${duration}s"
fi

echo "[INFO] Время выполнения: $duration_str" >> "$LOG_FILE"

# Анализ результата
if grep -q "Warning:" "$LOG_FILE"; then
    MSG=$(tail -n 30 "$LOG_FILE" | sed 's/&/%26/g; s/#/%23/g; s/"/%22/g; s/'"'"'/%27/g; s/</%3C/g; s/>/%3E/g; s/$/%0A/g')
else
    MSG="✅ rkhunter не нашёл предупреждений. База обновлена и проверка выполнена успешно."
fi

# Отправка уведомления в Telegram
send_telegram "rkhunter report for RaikoVPN:%0AНачало: $start_time_human%0AВремя выполнения: $duration_str%0A%0A$MSG"

exit 0
