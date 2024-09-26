#!/usr/bin/env bash

set -e

# Prepare DB (Migrate if exists; else Create db & Migrate)
sh ./docker/db_prepare.sh

# Run command if defined in the Dockerfile
exec "$@"
