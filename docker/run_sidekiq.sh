#!/usr/bin/env bash

set -e

# Start sidekiq
bundle exec sidekiq -e $RAILS_ENV -C config/sidekiq.yml

# Run commands
exec "$@"
