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

# Run db migrations
echo "Preparing database..."
bundle exec rake db:migrate RAILS_ENV=$RAILS_ENV 
echo "Database migration done!"

# Start the web server
mkdir -p ./tmp/pids
bundle exec puma -C config/puma.rb -e $RAILS_ENV

# Run commands
exec "$@"
