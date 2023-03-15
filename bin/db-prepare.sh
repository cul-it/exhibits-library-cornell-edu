#! /bin/sh

# If the database exists, migrate. Otherwise setup (create and migrate)
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:environment:set RAILS_ENV=test db:create db:schema:load
echo "Database Migration Done!"
