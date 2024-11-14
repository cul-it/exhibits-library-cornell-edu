#!/usr/bin/env bash

set -e

# Start sidekiq
echo "Starting up sidekiq..."
bundle exec sidekiq -e $RAILS_ENV -C config/sidekiq.yml

# Run commands
exec "$@"
