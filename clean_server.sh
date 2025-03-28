#!/bin/bash

LOGFILE="/var/log/cleanup.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting cleanup" >> $LOGFILE

# 1. Очистка временных файлов
if [ -d "/tmp" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning temporary files..." >> $LOGFILE
    rm -rf /tmp/*
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Directory /tmp does not exist!" >> $LOGFILE
fi

if [ -d "/var/tmp" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning /var/tmp..." >> $LOGFILE
    rm -rf /var/tmp/*
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Directory /var/tmp does not exist!" >> $LOGFILE
fi

# 2. Очистка старых логов (оставляем только последние 4 дня)
echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning old logs..." >> $LOGFILE
find /var/log -type f -name "*.log" -mtime +4 -exec rm -f {} \;

# 3. Обновление пакетов
echo "$(date '+%Y-%m-%d %H:%M:%S') - Updating system packages..." >> $LOGFILE
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y

# 4. Удаление скачанных пакетов
echo "$(date '+%Y-%m-%d %H:%M:%S') - Removing downloaded packages..." >> $LOGFILE
apt-get autoclean -y
apt-get autoremove -y

# 5. Очистка кэша Snap
echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning Snap cache..." >> $LOGFILE
rm -rf /var/lib/snapd/cache/*

# 6. Перезагрузка
if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Rebooting the system..." >> $LOGFILE
    reboot
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleanup failed, system will not be rebooted." >> $LOGFILE
fi
