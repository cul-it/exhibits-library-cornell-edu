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

# Clean up anonymous search records > 7 days
every :day, at: '1:00am' do
  rake 'blacklight:delete_old_searches[7]'
end

# Clean up tmp/network_files > 50GB
every :day, at: '2:05am' do
  rake 'spotlight:riiif:clear_cache'
end

# Clean up PaperTrail versions > 365 days
every :day, at: '3:00am' do
  rake 'spotlight:paper_trail:clear[365]'
end
