#!/usr/bin/env bash
# ! /bin/sh

echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo '-----------------------  RUNNING ENTRY POINT  -----------------------'
echo '====================================================================='

set -e

# Prepare DB (Migrate if exists; else Create db & Migrate)
sh ./docker/db-prepare.sh

# Run the command defined in compose.yaml
exec "$@"

# Start sidekiq
bundle exec sidekiq -d -L log/sidekiq.log -e development

# Start the web server
mkdir -p ./tmp/pids
bundle exec puma -C config/puma.rb
