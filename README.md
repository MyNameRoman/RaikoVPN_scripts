# RaikoVPN_scripts

Этот репозиторий содержит скрипты для автоматизации различных задач на VPS-сервере, используемом для работы с VPN и других сервисов.

## Скрипты

### 1. `clean_server.sh`

Скрипт `clean_server.sh` предназначен для автоматической очистки системы от ненужных файлов, обновления пакетов и перезагрузки сервера. Скрипт выполняется раз в 4 дня в 5:30 утра через `cron` и решает следующие задачи:

- Очистка временных файлов из каталогов `/tmp` и `/var/tmp`.
- Удаление лог-файлов старше 4 дней.
- Обновление всех пакетов системы.
- Удаление скачанных пакетов с помощью `apt-get`.
- Очистка кэша Snap.
- Перезагрузка сервера, если все предыдущие шаги были выполнены успешно.

Пример кода скрипта:
```bash
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
```

### 2. `setup-vps.sh`

Этот скрипт используется для быстрой инициализации VPS, включая установку необходимых пакетов и настройку системы, включая Docker, Docker Compose, fail2ban, настройку swap и многое другое.

**Что делает этот скрипт:**
- Обновляет систему.
- Устанавливает основные пакеты: `curl`, `wget`, `git`, `iptables`, и другие.
- Устанавливает Docker и Docker Compose.
- Настроивает защиту с помощью fail2ban.
- Настроит swap (2GB).
- Устанавливает и настраивает x3-ui для VPN.
- Выполняет настройку TCP для повышения производительности.
- Настроит firewall с помощью UFW.
- Настроит автоматические обновления для безопасности.
- Запускает Docker и другие сервисы.

Пример кода скрипта:
```bash
#!/bin/bash

# Обновляем систему
echo "Обновляем систему..."
apt update -y
apt upgrade -y

# Устанавливаем необходимые пакеты
echo "Устанавливаем необходимые пакеты..."
apt install -y curl wget gnupg2 lsb-release ca-certificates unzip iptables git

# Устанавливаем Docker
echo "Устанавливаем Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Устанавливаем Docker Compose
echo "Устанавливаем Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Устанавливаем fail2ban для защиты от атак
echo "Устанавливаем fail2ban..."
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# Устанавливаем и настраиваем swap (2GB)
echo "Настроим swap..."
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab

# Устанавливаем x3-ui VPN
echo "Устанавливаем x3-ui VPN..."
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)

# Настройки для производительности

## Настройки TCP
echo "Настройка TCP..."
sysctl -w net.ipv4.tcp_congestion_control=cubic
sysctl -w net.ipv4.tcp_rmem='4096 87380 16777216'
sysctl -w net.ipv4.tcp_wmem='4096 65536 16777216'
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -p

# Настроим firewall (UFW)
echo "Настроим firewall..."
apt install -y ufw
ufw default allow outgoing
ufw default deny incoming
ufw allow ssh
(Порты скрыты скрипт для ознакомления)
ufw enable

# Включаем и настраиваем автоматические обновления
echo "Настроим автоматические обновления..."
apt install -y unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades

# Запускаем Docker
echo "Запускаем Docker"
systemctl enable docker
systemctl start docker

# Проверка статуса всех сервисов
echo "Проверяем статус сервисов..."
systemctl status docker
systemctl status x3-ui

echo "Установка и настройка завершена!"
# Перезагрузка сервера
reboot
```

## Установка и запуск

1. Клонируйте репозиторий на ваш VPS:

```bash
git clone https://github.com/username/RaikoVPN_scripts.git
cd RaikoVPN_scripts
```

2. Сделайте скрипты исполнимыми:

```bash
chmod +x clean_server.sh
chmod +x setup-vps.sh
```

3. Настройте выполнение `clean_server.sh` через `cron` (для автоматической очистки):

```bash
crontab -e
```

Добавьте следующую строку для выполнения скрипта каждый раз в 4 дня в 5:30 утра:

```bash
30 5 */4 * * /path/to/clean_server.sh
```

4. Запустите `setup-vps.sh` для быстрой инициализации вашего сервера:

```bash
./setup-vps.sh
```

---

### Полезные советы

- Убедитесь, что у вас есть достаточные права для выполнения скриптов (например, root или через `sudo`).
- Обновление пакетов и настройка безопасности поможет вам поддерживать сервер в актуальном и безопасном состоянии.
- Используйте `clean_server.sh` для поддержания вашего VPS в чистоте, чтобы избежать накопления ненужных файлов и старых логов.
