#!/bin/bash
# install_admincluster.sh — Скрипт установки компонентов AdminClusterMonitor

set -e

echo "=== Установка AdminClusterMonitor ==="

# Каталоги
mkdir -p /opt/admincluster
mkdir -p /etc/admincluster
mkdir -p /var/log/admincluster

# Копирование исполняемых скриптов
cp scripts/admincluster_run.sh /opt/admincluster/
cp scripts/admincluster_notify.sh /opt/admincluster/
chmod +x /opt/admincluster/*.sh

# Копирование конфигураций (если еще не существуют)
if [ ! -f /etc/admincluster/config.conf ]; then
    cp config.conf.example /etc/admincluster/config.conf
fi
if [ ! -f /etc/admincluster/profiles.json ]; then
    cp profiles.json.example /etc/admincluster/profiles.json
fi

# Настройка прав
chown -R root:root /opt/admincluster /etc/admincluster
chmod 750 /opt/admincluster
chmod 600 /etc/admincluster/config.conf 2>/dev/null || true

# Systemd units
cp systemd/admincluster-monitor@.service /etc/systemd/system/
cp systemd/admincluster-monitor@.timer /etc/systemd/system/

# Logrotate
if [ -f logrotate_admincluster ]; then
    cp logrotate_admincluster /etc/logrotate.d/admincluster
fi

systemctl daemon-reload

echo "Установка завершена."
echo "1. Задайте параметры в /etc/admincluster/config.conf и profiles.json"
echo "2. Активируйте таймер: systemctl enable --now admincluster-monitor@prod.timer"
