#!/usr/bin/env bash

set -e

WORKDIR="/exhibits"
ENVFILE="${WORKDIR}/.env"
if [ ! -f "$ENVFILE" ]; then
    ruby docker/get_env.rb $RAILS_ENV $WORKDIR
fi

export RAILS_LOG_TO_STDOUT="1"

if [ "${RAILS_ENV}" != "development" ] && [ "${RAILS_ENV}" != "test" ]
then
  bundle exec whenever --update-crontab
  cron
fi

# Prepare DB (Migrate if exists; else Create db & Migrate)
sh ./docker/db_prepare.sh

# Run the command defined in compose.yaml
exec "$@"

# Start sidekiq
bundle exec sidekiq -d -L log/sidekiq.log -e development

# Start the web server
mkdir -p ./tmp/pids
bundle exec puma -C config/puma.rb
