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
