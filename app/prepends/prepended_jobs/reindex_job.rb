# frozen_string_literal: true
# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::ReindexJob
module PrependedJobs::ReindexJob
  # Override Spotlight ReindexJob#perform method
  # * skip exceptions when exhibit_or_resources is an Exhibit
  # * do NOT skip exceptions when exhibit_or_resources is a resource to capture upload exceptions
  def perform(exhibit_or_resources, log_entry = nil, validity_token = nil)
    return unless still_valid?(exhibit_or_resources, validity_token)

    # BEGIN CUSTOMIZATION elr37 - capture exceptions and continue to process remaining resources
    logger.info("Using prepended ReindexJob.perform method")
    skip_exceptions = exhibit_or_resources.kind_of?(Spotlight::Exhibit) ? true : false
    logger.info("-- skipping exceptions that occur during reindexing") if skip_exceptions
    # END CUSTOMIZATION
    resource_list(exhibit_or_resources).each do |resource|
      # BEGIN CUSTOMIZATION elr37 - capture exceptions and continue to process remaining resources
      begin
        resource.reindex(log_entry)
      rescue Exception => e
        skipped = skip_exceptions ? "SKIPPING " : ""
        logger.warn("#{skipped}RESOURCE REINDEX FAILURE: Exception reindexing resource #{resource.id} in exhibit #{resource.exhibit_id} with upload_id #{resource.upload_id}.  Cause: #{e.class}: #{e.message}")
        raise e unless skip_exceptions
      end
      # END CUSTOMIZATION
    end
  end
end
