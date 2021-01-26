#!/usr/bin/env bash
# ! /bin/sh

echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo '-----------------------  RUNNING ENTRY POINT  -----------------------'
echo '====================================================================='

set -e

# Wait for DB services
sh ./bin/db-wait.sh

# Prepare DB (Migrate if exists; else Create db & Migrate)
sh ./bin/db-prepare.sh

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Run the command defined in docker-compose.yml
exec "$@"

bundle exec sidekiq -d -L log/sidekiq.log -e development
