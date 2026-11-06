# frozen_string_literal: true

module Spotlight
  ##
  # Process a CSV upload into new Spotlight::Resource::Upload objects
  class AddUploadsFromCsv < Spotlight::ApplicationJob
    include Spotlight::JobTracking

    with_job_tracking(resource: ->(job) { job.arguments[1] })

    attr_reader :count, :errors

    ### BEGIN CUSTOMIZATION - catch exceptions from notification to prevent job from repeating if email fails
    # NOTE: Cannot use prepend to override after_perform
    after_perform do |job|
      csv_data, exhibit, user, csv_file_name = job.arguments
      csv_info = { csv_data: csv_data, csv_file_name: csv_file_name }
      begin
        Spotlight::IndexingCompleteMailer.documents_indexed(
          csv_info,
          exhibit,
          user,
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
      @csv_file_name = csv_file_name

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

      processed_csv(csv_data, exhibit).each do |row|
        # Remove the URL from the row and skip if it's blank
        url = row.delete('url')
        next if url.blank?

        # Create a new resource for each row of data, and build the upload if the URL is not '~'
        resource = Spotlight::Resources::Upload.new(data: row, exhibit: exhibit)
        ### BEGIN CUSTOMIZATION - Updated resource to has_many uploads association
        resource.uploads.build(remote_image_url: url) unless url == '~'
        ### END CUSTOMIZATION
        yield resource
      end
    end

    def processed_csv(csv_data, exhibit)
      csv_data.map do |row|
        row.map do |label, column|
          next if column.blank?

          [label, processed_value(label, column, exhibit)]
        end.compact.to_h
      end.compact
    end

    def processed_value(key, value, exhibit)
      # Encode the value to UTF-8
      encoded_value = value.encode('UTF-8', invalid: :replace, undef: :replace, replace: "\uFFFD")

      # Check if the key is a multivalued field and split values if delimiter is enabled and present in the value
      if delimiter.present? && encoded_value.include?(delimiter) && multivalued_fields(exhibit).include?(key)
        encoded_value.split(delimiter).map(&:strip).compact_blank
      else
        encoded_value
      end
    end

    def delimiter
      Spotlight::Engine.config.csv_upload_multivalued_field_delimiter
    end

    def multivalued_fields(exhibit)
      upload_fields = Spotlight::Resources::Upload.fields(exhibit).filter_map { |field| field.field_name.to_s if field.is_multiple? }
      custom_fields = exhibit.custom_fields.filter_map { |field| field.slug.to_s if field.is_multiple? }
      upload_fields + custom_fields
    end
  end
end
