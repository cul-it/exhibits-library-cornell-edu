# frozen_string_literal: true

module Spotlight
  ##
  # Process a CSV upload into new Spotlight::Resource::Upload objects
  class AddUploadsFromCsv < Spotlight::ApplicationJob
    include Spotlight::JobTracking
    attr_reader :count
    attr_reader :errors

    after_perform do |job|
      csv_data, exhibit, user = job.arguments
      Spotlight::IndexingCompleteMailer.documents_indexed(
        csv_data,
        exhibit,
        user,
        indexed_count: job.count,
        errors: job.errors
      ).deliver_now
    ### BEGIN CUSTOMIZATION elr37 - catch exceptions from notification to prevent job from repeating if email fails
    # NOTE: Cannot use prepend to override after_perform
    rescue RuntimeError => e
      Rails.application.config.debug_logger.warn("********************** EMAIL FAILURE  => exception #{e.class.name} : #{e.message}")
    end
    ### END CUSTOMIZATION

    def perform(csv_data, exhibit, _user)
      @count = 0
      @errors = {}

      resources(csv_data, exhibit).each_with_index do |resource, index|
        if resource.save_and_index
          @count += 1
        else
          @errors[index + 1] = resource.errors.full_messages + resource.upload&.errors&.full_messages
        end
      end
    end

    private

    def resources(csv_data, exhibit)
      return to_enum(:resources, csv_data, exhibit) unless block_given?

      encoded_csv(csv_data).each do |row|
        url = row.delete('url')
        next unless url.present?

        resource = Spotlight::Resources::Upload.new(
          data: row,
          exhibit: exhibit
        )
        resource.build_upload(remote_image_url: url) unless url == '~'

        yield resource
      end
    end

      def encoded_csv(csv)
        csv.map do |row|
          row.map do |label, column|
            [label, column.encode('UTF-8', invalid: :replace, undef: :replace, replace: "\uFFFD")] if column.present?
          end.compact.to_h
        end.compact
      end

    def job_tracking_resource
      arguments[1]
    end
  end
end
