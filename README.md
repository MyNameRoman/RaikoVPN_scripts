<p align="right">
  <a href="#️-raikovpn-scripts-eng">ENG</a>
</p>

# 📜 RaikoVPN Scripts

> Набор автоматизированных скриптов для обслуживания серверов RaikoVPN.

## ⚙️ Настройка перед использованием

Перед использованием **обязательно укажите свои данные**:

* `BOT_TOKEN` — токен Telegram-бота, полученный через [@BotFather](https://t.me/BotFather)
* `CHAT_ID` — ID чата, куда будут приходить уведомления. Узнать можно через [@userinfobot](https://t.me/userinfobot)

---

## 🧹 `cleanup_every_5days.sh`

Скрипт выполняет регулярную очистку системы каждые 5 дней:

* Удаляет **временные файлы** в `/tmp` и `/var/tmp`, которым больше 1 суток
* Удаляет **старые логи** (старше 5 дней) в `/var/log`
* Очищает **кэш Snap**
* Ведёт лог выполнения в `/var/log/cleanup_every_5days.log`
* Отправляет уведомление в Telegram о статусе выполнения
* Перезагружает сервер по завершении (🟡 будь осторожен)

📌 **Рекомендуется использовать в cron каждые 5 дней**.

---

## 🔄 `daily_update.sh`

Скрипт для ежедневного обновления системы:

* Выполняет `apt-get update`, `upgrade`, `dist-upgrade`, `autoclean`, `autoremove`
* Логирует всё в `/var/log/daily_update.log`
* Измеряет общее время выполнения
* Уведомляет в Telegram об успехе или ошибке выполнения

📌 Идеален для ежедневного запуска через cron.

---

## 🛡️ `rkhunter-tg.sh`

Еженедельная проверка на rootkits с использованием **rkhunter**:

* Обновляет базу `rkhunter`
* Запускает проверку системы
* Анализирует лог на наличие `Warning`
* Отправляет отчёт в Telegram (включая последние 30 строк лога, если есть предупреждения)

📝 Лог: `/var/log/rkhunter-weekly.log`

📌 Запускать раз в неделю для повышения безопасности сервера.

---

## 🌐 `update_geo.sh`

Автоматическое обновление геофайлов **XUI** (например, для GeoIP-фильтрации):

* Логирует действия в `/var/log/xui_update.log`
* Запускает встроенное меню `x-ui` для обновления Geo-файлов
* Измеряет длительность выполнения
* Отправляет уведомление в Telegram по завершении

📌 Полезно запускать раз в день или при необходимости через cron.

---

## 🧾 Пример Cron-задач

```bash
# Ежедневное обновление в 3:00
0 3 * * * /bin/bash /путь/до/RaikoVPN_scripts/daily_update.sh

# Очистка каждые 5 дней в 4:00
0 4 */5 * * /bin/bash /путь/до/RaikoVPN_scripts/cleanup_every_5days.sh

# Еженедельная проверка по понедельникам в 2:00
0 2 * * 1 /bin/bash /путь/до/RaikoVPN_scripts/rkhunter-tg.sh

# Ежедневное обновление геофайлов в 1:00
0 1 * * * /bin/bash /путь/до/RaikoVPN_scripts/update_geo.sh
```


## 🛠️ RaikoVPN Scripts (ENG)
# 📜 RaikoVPN Scripts
> A collection of automated scripts for maintaining RaikoVPN servers.

## ⚙️ Setup Instructions

Before using any script, make sure to set the following:

- `BOT_TOKEN` — Your Telegram bot token from [@BotFather](https://t.me/BotFather)
- `CHAT_ID` — Your chat ID, available via [@userinfobot](https://t.me/userinfobot)

---

## 🧹 `cleanup_every_5days.sh`

This script performs a system cleanup every 5 days:

- Deletes **temporary files** in `/tmp` and `/var/tmp` that are older than 1 day
- Deletes **log files** older than 5 days in `/var/log`
- Clears **Snap cache**
- Logs everything to `/var/log/cleanup_every_5days.log`
- Sends Telegram notification about execution status
- Reboots the server after completion (⚠️ use with caution)

📌 **Recommended for use with cron every 5 days**

---

## 🔄 `daily_update.sh`

Performs daily package and system updates:

- Runs `apt-get update`, `upgrade`, `dist-upgrade`, `autoclean`, `autoremove`
- Logs everything to `/var/log/daily_update.log`
- Measures execution time
- Sends Telegram report on success or error

📌 Ideal for daily cron job.

---

## 🛡️ `rkhunter-tg.sh`

Weekly security scan using **rkhunter**:

- Updates `rkhunter` database
- Runs full system check
- Parses log file for `Warning:` entries
- Sends Telegram notification with the last 30 log lines if issues found

📝 Log file: `/var/log/rkhunter-weekly.log`

📌 Recommended to run weekly via cron.

---

## 🌐 `update_geo.sh`

Updates **XUI geo files** (e.g., for GeoIP filtering):

- Logs output to `/var/log/xui_update.log`
- Executes the `x-ui` menu update sequence
- Measures total duration
- Sends a detailed Telegram message after success

📌 Suitable for daily or on-demand execution.

---

## 🧾 Example Cron Jobs

```bash
# Daily update at 3:00 AM
0 3 * * * /bin/bash /path/to/RaikoVPN_scripts/daily_update.sh

# Cleanup every 5 days at 4:00 AM
0 4 */5 * * /bin/bash /path/to/RaikoVPN_scripts/cleanup_every_5days.sh

# Weekly rkhunter check on Mondays at 2:00 AM
0 2 * * 1 /bin/bash /path/to/RaikoVPN_scripts/rkhunter-tg.sh

# Daily geo file update at 1:00 AM
0 1 * * * /bin/bash /path/to/RaikoVPN_scripts/update_geo.sh
