# frozen_string_literal: true
# OVERRIDE of Spotlight::ReindexJob to prevent an error in one resource killing an exhibit reindex process
module Spotlight
  ##
  # Reindex the given resources or exhibits
  class ReindexJob < ActiveJob::Base
    queue_as :default

    # The validity checker is a seam for implementations to expire unnecessary
    # indexing tasks if it becomes redundant while waiting in the job queue.
    class_attribute :validity_checker, default: Spotlight::ValidityChecker.new
    self.validity_checker ||= Spotlight::ValidityChecker.new if Rails.version < '5.2'

    before_perform do |job|
      job_log_entry = log_entry(job)
      next unless job_log_entry

      items_reindexed_estimate = resource_list(job.arguments.first).sum do |resource|
        resource.document_builder.documents_to_index.size
      ### BEGIN CUSTOMIZATION elr37 - capture exceptions and continue to process remaining resources
      # NOTE: Cannot use prepend to override before_perform
      rescue Exception => e # rubocop:disable Lint/RescueException
        skipping = skip_before_perform_exceptions?(job)
        skipped = skipping ? "SKIPPING " : ""
        logger.warn("#{skipped}RESOURCE DOCUMENT_BUILDER FAILURE: Exception preparing for reindexing resource " \
                    "#{resource.id} in exhibit #{resource.exhibit_id} with upload_id #{resource.upload_id}.  " \
                    "Cause: #{e.class}: #{e.message}")
        raise e unless skipping
      end
      ### END CUSTOMIZATION
      job_log_entry.update(items_reindexed_estimate: items_reindexed_estimate)
    end

    around_perform do |job, block|
      job_log_entry = log_entry(job)
      job_log_entry&.in_progress! ### CUSTOMIZATION to appease rubocop only

      begin
        block.call
      rescue
        job_log_entry&.failed! ### CUSTOMIZATION to appease rubocop only
        raise
      end

      job_log_entry&.succeeded! ### CUSTOMIZATION to appease rubocop only
    end

    def self.perform_later(exhibit_or_resources, log_entry = nil)
      validity_token = validity_checker.mint(exhibit_or_resources)

      super(exhibit_or_resources, log_entry, validity_token)
    end

    # Override Spotlight ReindexJob#perform method
    # * skip exceptions when exhibit_or_resources is an Exhibit
    # * do NOT skip exceptions when exhibit_or_resources is a resource to capture upload exceptions
    def perform(exhibit_or_resources, log_entry = nil, validity_token = nil)
      return unless still_valid?(exhibit_or_resources, validity_token)

      resource_list(exhibit_or_resources).each do |resource|
        resource.reindex(log_entry)
      ### BEGIN CUSTOMIZATION elr37 - capture exceptions and continue to process remaining resources
      rescue Exception => e # rubocop:disable Lint/RescueException
        skipping = skip_perform_exceptions?(exhibit_or_resources)
        skipped = skipping ? "SKIPPING " : ""
        logger.warn("#{skipped}RESOURCE REINDEX FAILURE: Exception reindexing resource #{resource.id} in exhibit " \
                    "#{resource.exhibit_id} with upload_id #{resource.upload_id}.  Cause: #{e.class}: #{e.message}")
        raise e unless skipping
      end
      ### END CUSTOMIZATION
    end

    private

      def resource_list(exhibit_or_resources)
        if exhibit_or_resources.is_a?(Spotlight::Exhibit)
          exhibit_or_resources.resources.find_each
        elsif exhibit_or_resources.is_a?(Enumerable)
          exhibit_or_resources
        else
          Array(exhibit_or_resources)
        end
      end

      def log_entry(job)
        job.arguments.second if job.arguments.second.is_a?(Spotlight::ReindexingLogEntry)
      end

      def still_valid?(exhibit_or_resources, validity_token)
        return true unless validity_token

        validity_checker.check exhibit_or_resources, validity_token
      end

      ### BEGIN CUSTOMIZATION elr37 - check if exception happened on an exhibit, indicating the exception should be skipped
      def skip_perform_exceptions?(exhibit_or_resources)
        skip_exceptions = exhibit_or_resources.is_a?(Spotlight::Exhibit) ? true : false
        logger.info("-- skipping exceptions that occur during reindexing") if skip_exceptions
        skip_exceptions
      end

      def skip_before_perform_exceptions?(job)
        skip_exceptions = job.arguments.first.is_a?(Spotlight::Exhibit) ? true : false
        logger.info("-- skipping exceptions that occur before reindexing") if skip_exceptions
        skip_exceptions
      end
    ### END CUSTOMIZATION
  end
end
