#!/usr/bin/env bash

set -e

# Install gems
bundle install

# Prepare assets
bundle exec rails test:prepare

# If the database exists, migrate. Otherwise setup (create and migrate)
echo "Preparing Database..."
bundle exec rake db:environment:set RAILS_ENV=test db:migrate 2>/dev/null || bundle exec rake db:environment:set RAILS_ENV=test db:create db:schema:load
echo "Database Migration Done!"

# Run commands
exec "$@"
