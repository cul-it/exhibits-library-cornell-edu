require 'English'

namespace :spotlight do
  namespace :riiif do
    desc 'Clear the riiif cache if it exceeds 50GB'
    task clear_cache: :environment do
      # Get the size of the tmp/network_files directory
      size = `du -sh tmp/network_files`.split("\t").first
      Rails.logger.info("Size of tmp/network_files before cleanup is #{size}.")

      # If the size is over 50GB, delete the oldest files until under 50GB
      deleted_file_count = 0
      while !size.nil? && size.match(/^(\d+(?:\.\d+)?)G$/) && Regexp.last_match(1).to_f > 50
        # Get the oldest file in the tmp/network_files directory
        oldest_file = `ls -t tmp/network_files | tail -n 1`.chomp
        # Delete the oldest file
        `rm tmp/network_files/#{oldest_file}`

        if $CHILD_STATUS.success?
          deleted_file_count += 1
          # Get the new size of the tmp/network_files directory
          size = `du -sh tmp/network_files`.split("\t").first
        else
          # If removing the oldest file fails, there's something unexpected in the directory
          Rails.logger.error("Failed to delete tmp/network_files/#{oldest_file} while running riiif:clear_cache rake task.")
          break
        end
      end
      Rails.logger.info("Completed spotlight:riiif:clear_cache rake task." \
        " Cleared #{deleted_file_count} files from tmp/network_files." \
        " Directory size is now #{size}.")
    end
  end

  namespace :paper_trail do
    desc 'Clear PaperTrail versions older than the specified number of days'
    task :clear, [:days_old] => [:environment] do |_t, args|
      args.with_defaults(days_old: '365')
      days_old = args[:days_old]

      # Handle unexpected argument
      raise ArgumentError, 'days_old is expected to be an integer' unless days_old.to_i.to_s == days_old
      raise ArgumentError, 'days_old is expected to be greater than 0' if days_old.to_i <= 0

      # Delete PaperTrail versions older than the specified number of days
      PaperTrail::Version.where('created_at < ?', Time.zone.today - days_old.to_i).delete_all
      Rails.logger.info("Completed spotlight:paper_trail:clear rake task for PaperTrail versions older than #{days_old} days ago.")
    end
  end
end
