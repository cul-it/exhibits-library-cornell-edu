#!/usr/bin/env bash
# ! /bin/sh

set -e

# Prepare DB (Migrate if exists; else Create db & Migrate)
sh ./docker/db_prepare.sh

# Run the command defined in compose.yaml
exec "$@"
