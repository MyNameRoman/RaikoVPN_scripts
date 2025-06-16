
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Telegram Notifications](https://img.shields.io/badge/Telegram-Notifications-blue)](https://telegram.org/)
[![Bash](https://img.shields.io/badge/Bash-5.1%2B-green)](https://www.gnu.org/software/bash/)

<p align="right">
  <a href="#english-version">ENG</a>
</p>

# 📜 RaikoVPN Scripts

> Набор автоматизированных скриптов для развертывания и обслуживания VPS-серверов в частности на базе Debian 12

## 📜 Лицензия
Проект использует MIT License - полный текст в файле [LICENSE](LICENSE).

## 🚀 Быстрый старт
```bash
git clone https://github.com/MyNameRoman/RaikoVPN_scripts.git
cd RaikoVPN_scripts
echo "BOT_TOKEN=ваш_токен" > .env
echo "CHAT_ID=ваш_chat_id" >> .env
chmod +x *.sh
```

## ⚙️ Настройка
Перед использованием задайте:
- `BOT_TOKEN` от [@BotFather](https://t.me/BotFather)
- `CHAT_ID` из [@userinfobot](https://t.me/userinfobot)

## 📋 Скрипты

### 🧹 `cleanup_every_5days.sh`
**Функции**:
- Очистка временных файлов и логов
- Уведомления в Telegram
- Логирование в `/var/log/cleanup.log`

**Cron**:
```bash
0 4 */5 * * /path/to/cleanup_every_5days.sh
```

### 🔄 `daily_update.sh`
**Функции**:
- Обновление системы (apt)
- Логирование в `/var/log/update.log`
- Отчет в Telegram

**Cron**:
```bash
0 3 * * * /path/to/daily_update.sh
```

### 🛡️ `rkhunter-tg.sh`
**Функции**:
- Проверка безопасности
- Отправка отчета
- Логи в `/var/log/rkhunter.log`

**Cron**:
```bash
0 2 * * 1 /path/to/rkhunter-tg.sh
```

### 🌐 `update_geo.sh`
**Функции**:
- Обновление GeoIP
- Логирование в `/var/log/geo_update.log`
- Уведомления

**Cron**:
```bash
0 1 * * * /path/to/update_geo.sh
```

## 💬 Поддержка
- Telegram: [@Chamomile211](http://t.me/Chamomile211)
- Issues: [GitHub Issues](https://github.com/MyNameRoman/RaikoVPN_scripts/issues)

---

# English Version

## 🚀 Quick Start
```bash
git clone https://github.com/MyNameRoman/RaikoVPN_scripts.git
cd RaikoVPN_scripts
echo "BOT_TOKEN=your_token" > .env
echo "CHAT_ID=your_chat_id" >> .env
chmod +x *.sh
```

## ⚙️ Configuration
Required:
- `BOT_TOKEN` from [@BotFather](https://t.me/BotFather)
- `CHAT_ID` via [@userinfobot](https://t.me/userinfobot)

## 📋 Scripts

### 🧹 `cleanup_every_5days.sh`
**Features**:
- System cleanup
- Telegram notifications
- Logs to `/var/log/cleanup.log`

**Cron**:
```bash
0 4 */5 * * /path/to/cleanup_every_5days.sh
```

### 🔄 `daily_update.sh`
**Features**:
- System updates
- Logging to `/var/log/update.log`
- Telegram reports

**Cron**:
```bash
0 3 * * * /path/to/daily_update.sh
```

### 🛡️ `rkhunter-tg.sh`
**Features**:
- Security checks
- Telegram reports
- Logs to `/var/log/rkhunter.log`

**Cron**:
```bash
0 2 * * 1 /path/to/rkhunter-tg.sh
```

### 🌐 `update_geo.sh`
**Features**:
- GeoIP updates
- Logging to `/var/log/geo_update.log`
- Notifications

**Cron**:
```bash
0 1 * * * /path/to/update_geo.sh
```

## 💬 Support
- Telegram: [@Chamomile211](http://t.me/Chamomile211)
- Issues: [GitHub Issues](https://github.com/MyNameRoman/RaikoVPN_scripts/issues)
