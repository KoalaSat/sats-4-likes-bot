#!/usr/bin/env bash

set -e

if [ "$1" == "docker-start" ]; then
  shift

  bundle exec whenever --update-crontab

  if [ "$1" == "start-cron" ]; then
    shift

    cron

    if [ "$1" == "tail-cron-log" ]; then
      shift

      touch "$CRON_LOG_PATH"
      tail -f "$CRON_LOG_PATH"
    fi
  fi
fi

exec "$@"