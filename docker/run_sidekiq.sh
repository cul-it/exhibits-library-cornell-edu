#!/usr/bin/env bash

set -e

# Get environment variables
WORKDIR="/exhibits"
ENVFILE="${WORKDIR}/.env"
if [ ! -f "$ENVFILE" ]; then
    ruby docker/get_env.rb $RAILS_ENV $WORKDIR
fi

# Start sidekiq
echo "Starting up sidekiq..."
bundle exec sidekiq -e $RAILS_ENV -C config/sidekiq.yml

# Run commands
exec "$@"