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

# Run the command defined in docker-compose.yml
exec "$@"
