# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# Send the cron output to container STDOUT so its accessible in CloudWatch log streams
set :output, '/proc/1/fd/1'

# Ensure crunner has access to envs
# Support for running rake via whenever on docker
# https://stackoverflow.com/a/43832334
# https://github.com/javan/whenever/issues/850
ENV.each { |k, v| env(k, v) }

# Clean up tmp/network_files > 50GB
every :day, at: '1:00am' do
  rake 'spotlight:riiif:clear_cache'
end

# Clean up anonymous search records > 7 days
every :wednesday, at: '2:00am' do
  rake 'blacklight:delete_old_searches[7]'
end

# Clean up PaperTrail versions > 365 days
every :wednesday, at: '3:00am' do
  rake 'spotlight:paper_trail:clear[365]'
end

# Clean up guest users > 2 days
every :wednesday, at: '4:00am' do
  rake 'devise_guests:delete_old_guest_users[2]'
end
