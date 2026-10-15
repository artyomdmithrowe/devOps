#!/bin/bash

SERVICE="$1"

if [ -z "$SERVICE" ]; then
  echo "Usage: $0 <service>"
  exit 1
fi

if systemctl is-active --quiet "$SERVICE"; then
  echo "Service $SERVICE is active"
else
  echo "Service $SERVICE is not active"
  echo "Last 10 log lines:"

  sudo journalctl -u "$SERVICE" -n 10 --no-pager
fi

echo "Errors in syslog for the last hour:"

if [ -f /var/log/syslog ]; then
  START_TIME=$(date --date="1 hour ago" "+%b %e %H:%M:%S")

  sudo awk -v start="$START_TIME" '$0 >= start' /var/log/syslog |
    grep -i "error" |
    wc -l
else
  echo "/var/log/syslog not found"
fi