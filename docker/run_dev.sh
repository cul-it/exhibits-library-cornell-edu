#!/usr/bin/env bash

set -e

# Direct logs to stdout
export RAILS_LOG_TO_STDOUT="1"

# If the database exists, migrate. Otherwise setup (create and migrate)
echo "Preparing Database..."
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:environment:set RAILS_ENV=development db:create db:schema:load
echo "Database Migration Done!"

# Start sidekiq
bundle exec sidekiq -L log/sidekiq.log -e $RAILS_ENV -C config/sidekiq.yml -d

# Start the web server
mkdir -p ./tmp/pids
bundle exec puma -C config/puma.rb -e $RAILS_ENV

# Run commands
exec "$@"
