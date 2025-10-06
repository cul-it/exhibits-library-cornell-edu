#!/usr/bin/env bash

set -e

# Direct logs to stdout
export RAILS_LOG_TO_STDOUT="1"

# Uncomment to test cron jobs in dev environment
# bundle exec whenever --update-crontab --set "environment=${RAILS_ENV}"
# cron

# If the database exists, migrate. Otherwise setup (create and migrate)
echo "Preparing Database..."
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:environment:set RAILS_ENV=development db:create db:schema:load
echo "Database Migration Done!"

# Install node modules
bin/yarn

# Start the web server
mkdir -p ./tmp/pids
rm -f ./tmp/pids/*
bin/dev

# Run commands
exec "$@"
