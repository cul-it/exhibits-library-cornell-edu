# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::Resources::CsvUploadController
module PrependedControllers::CsvUploadController
  # Overrides create method to display file name in the email message
  def create
    csv = CSV.parse(csv_io_param, headers: true, return_headers: false).map(&:to_hash)
    Spotlight::AddUploadsFromCsv.perform_later(csv, current_exhibit, current_user, csv_io_name)
    flash[:notice] = t('spotlight.resources.upload.csv.success', file_name: csv_io_name)
    redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit)
  end
end
