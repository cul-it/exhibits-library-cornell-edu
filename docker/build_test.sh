#!/usr/bin/env bash

set -e

# Install gems
bundle install

# Prepare DB (Migrate if exists; else Create db & Migrate)
sh ./docker/db_prepare.sh

# Run commands
exec "$@"
