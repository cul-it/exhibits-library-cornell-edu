# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::Resources::CsvUploadController
module PrependedControllers::CsvUploadController
  # Overrides create method to display file name in the email message
  def create
    begin
      csv = CSV.parse(csv_io_param, headers: true, return_headers: false).map(&:to_hash)

      # if headers are not valid, abort because metadata may be lost
      if invalid_headers?(csv)
        flash[:error] = t('spotlight.resources.upload.invalid_csv_headers')
        redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit)
        return
      end

      Spotlight::AddUploadsFromCsv.perform_later(csv, current_exhibit, current_user, csv_io_name)
      flash[:notice] = t('spotlight.resources.upload.csv.success', file_name: csv_io_name)
    rescue CSV::MalformedCSVError => e
      Rails.logger.error("CSV Malformed: #{e.message}")
      flash[:error] = t('spotlight.resources.upload.malformed_non_UTF8_csv_data', error_message: e.message)
    end
    redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit)
  end

  private

  def invalid_headers?(csv)
    expected_headers = %w[url full_title_tesim spotlight_upload_description_tesim spotlight_upload_attribution_tesim spotlight_upload_date_tesim spotlight_copyright_tesim]
    actual_headers = csv.first.keys
    (expected_headers - actual_headers).any?
  end
end
