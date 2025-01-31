# frozen_string_literal: true

module Spotlight
  ##
  # Process a CSV upload into new Spotlight::Resource::Upload objects
  class AddUploadsFromCsv < Spotlight::ApplicationJob
    include Spotlight::JobTracking
    with_job_tracking(resource: ->(job) { job.arguments[1] })

    attr_reader :count
    attr_reader :errors

    ### BEGIN CUSTOMIZATION - catch exceptions from notification to prevent job from repeating if email fails
      # NOTE: Cannot use prepend to override after_perform
    after_perform do |job|
      csv_data, exhibit, user, csv_file_name = job.arguments
      begin
        Spotlight::IndexingCompleteMailer.documents_indexed(
          csv_data,
          exhibit,
          user,
          csv_file_name,
          indexed_count: job.count,
          errors: job.errors
        ).deliver_now
      rescue StandardError => e
        Rails.logger.error("********************** EMAIL FAILURE  => exception #{e.class.name} : #{e.message}")
      end
    end
    ### END CUSTOMIZATION

    def perform(csv_data, exhibit, _user, csv_file_name)
      @count = 0
      @errors = {}

      resources(csv_data, exhibit).each_with_index do |resource, index|
        if resource.save_and_index
          @count += 1
        else
          ### BEGIN CUSTOMIZATION - Handle has_many uploads association
          @errors[index + 1] = (resource.errors.full_messages + (resource.uploads.map { |u| u.errors&.full_messages })).flatten
          ### END CUSTOMIZATION
        end
      end
    end

    private

    def resources(csv_data, exhibit)
      return to_enum(:resources, csv_data, exhibit) unless block_given?

      encoded_csv(csv_data).each do |row|
        url = row.delete('url')
        ### BEGIN CUSTOMIZATION - to appease rubocop
        next if url.blank?
        ### END CUSTOMIZATION

        resource = Spotlight::Resources::Upload.new(
          data: row,
          exhibit: exhibit
        )
        ### BEGIN CUSTOMIZATION - Updated resource to has_many uploads association
        resource.uploads.build(remote_image_url: url) unless url == '~'
        ### END CUSTOMIZATION

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
  end
end
