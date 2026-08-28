#!/bin/bash
# /opt/admincluster/admincluster_run.sh
# Скрипт запуска проверки профиля кластера 1С

CONFIG="/etc/admincluster/config.conf"
if [ -f "$CONFIG" ]; then
  . "$CONFIG"
fi

PROFILE=""
DRYRUN=0

while [[ $# -gt 0 ]]; do
  case $1 in
    --profile) PROFILE="$2"; shift 2;;
    --dry-run) DRYRUN=1; shift;;
    *) shift;;
  esac
done

LOG_TAG="admincluster-monitor"

if [[ -z "$PROFILE" ]]; then
  echo "Ошибка: не указан профиль (--profile NAME)" >&2
  exit 1
fi

CMD="/usr/bin/1cv8 -run ${EPF_PATH:-/opt/admincluster/AdminClusterMonitor.epf} --profile $PROFILE"
if [[ $DRYRUN -eq 1 ]]; then
  CMD="$CMD --dry-run"
fi

logger -t $LOG_TAG "Запуск проверки профиля $PROFILE (dryrun=${DRYRUN})"
$CMD 2>&1 | logger -t $LOG_TAG
