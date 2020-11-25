#!/bin/sh
set -e

db-wait.sh "$DATABASE_HOST:$DATABASE_PORT"

bundle exec rails db:migrate
bundle exec rails db:seed
