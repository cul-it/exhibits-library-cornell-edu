# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

### BEGIN CUSTOMIZATION (elr) - only use solr_wrapper on localhost
require 'solr_wrapper/rake_task' if Rails.env.development?
### END CUSTOMIZATION
