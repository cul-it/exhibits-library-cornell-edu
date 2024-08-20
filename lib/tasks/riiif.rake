namespace :riiif do
  desc 'Clear the riiif cache if it exceeds 50GB'
  task clear_cache: :environment do
    # Get the size of the tmp/network_files directory
    size = `du -sh tmp/network_files`.split("\t").first

    # If the size is over 50GB, delete the oldest files until under 50GB
    deleted_file_count = 0
    while !size.nil? && size.match(/^(\d+(?:\.\d+)?)G$/) && Regexp.last_match(1).to_f > 50
      # Get the oldest file in the tmp/network_files directory
      oldest_file = `ls -t tmp/network_files | tail -n 1`.chomp
      # Delete the oldest file
      `rm tmp/network_files/#{oldest_file}`
      deleted_file_count += 1
      # Get the new size of the tmp/network_files directory
      size = `du -sh tmp/network_files`.split("\t").first
    end
    Rails.logger.info("Completed riiif:clear_cache rake task. Cleared #{deleted_file_count} files from tmp/network_files.")
  end
end
