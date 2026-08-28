#!/bin/bash
# /opt/admincluster/admincluster_notify.sh
# Скрипт отправки алертов (Telegram / Email) при выявлении зависших процессов

CONFIG="/etc/admincluster/config.conf"
if [ -f "$CONFIG" ]; then
  . "$CONFIG"
fi

DRYRUN=0
FILE=""
PROFILE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --file) FILE="$2"; shift 2;;
    --profile) PROFILE="$2"; shift 2;;
    --dry-run) DRYRUN=1; shift;;
    *) shift;;
  esac
done

SUBJECT="AdminClusterMonitor: обнаружены старички в $PROFILE"
BODY="В профиле $PROFILE обнаружены процессы-старички без соединений. Отчёт: $FILE"

if [[ $DRYRUN -eq 1 ]]; then
  logger -t admincluster-monitor "DRYRUN: $SUBJECT - $BODY"
  echo "DRYRUN: $SUBJECT - $BODY"
  exit 0
fi

# Telegram Notification
if [[ -n "$TELEGRAM_BOT_TOKEN" && -n "$TELEGRAM_CHAT_ID" ]]; then
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_CHAT_ID}" \
    -d text="${SUBJECT}
${BODY}" >/dev/null 2>&1
fi

# Email Notification
if [[ -n "$ALERT_EMAIL" ]]; then
  echo -e "$BODY" | mail -s "$SUBJECT" "$ALERT_EMAIL"
fi

logger -t admincluster-monitor "Уведомление успешно отправлено для профиля $PROFILE"
