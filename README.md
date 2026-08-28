# AdminClusterMonitor

Практический учебный проект для администраторов 1С: мониторинг и безопасное управление процессами кластера 1С в среде Linux.

Разработано как практический инженерный ответ на статью [«Кластер 1С на заводских настройках»](https://infostart.ru/1c/articles/2775329).

## Структура репозитория

```text
.
├── config.conf.example              # Шаблон конфигурации путей и секретов
├── profiles.json.example            # Описание профилей кластеров 1С (RAS/порт)
├── logrotate_admincluster           # Конфигурация ротации логов
├── example_report.csv               # Пример структуры экспортируемого отчета
├── LICENSE.txt                      # MIT License
├── README.md                        # Документация
├── tests.md                         # Сценарии тестирования
├── scripts/
│   ├── install_admincluster.sh      # Установочный скрипт
│   ├── admincluster_run.sh          # Скрипт-обертка запуска проверки
│   └── admincluster_notify.sh       # Скрипт отправки уведомлений (TG/Email)
├── systemd/
│   ├── admincluster-monitor@.service # Systemd unit сервиса
│   └── admincluster-monitor@.timer   # Systemd таймер периодического запуска
└── src/
    └── AdminClusterMonitor.bsl      # Исходный код логики на BSL (1С:Предприятие)
```

## Быстрый старт

1. Склонируйте репозиторий:
   ```bash
   git clone https://github.com/<your-username>/AdminClusterMonitor.git
   cd AdminClusterMonitor
   ```
2. Выполните скрипт установки:
   ```bash
   sudo bash scripts/install_admincluster.sh
   ```
3. Отредактируйте параметры подключения в `/etc/admincluster/config.conf` и `/etc/admincluster/profiles.json`.
4. Запустите dry-run проверку:
   ```bash
   sudo /opt/admincluster/admincluster_run.sh --profile prod --dry-run
   ```
5. Активируйте таймер:
   ```bash
   sudo systemctl enable --now admincluster-monitor@prod.timer
   ```

## Авторы
Николай и Нинель Щербаковы
