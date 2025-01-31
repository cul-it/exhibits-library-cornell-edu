# frozen_string_literal: true

module Spotlight
  ##
  # Notify the curator that we're finished processing a
  # batch upload
  # CUSTOMIZATION: bundled csv data and the csv file name into csv_info hash
  class IndexingCompleteMailer < ApplicationMailer
    def documents_indexed(csv_info, exhibit, user, indexed_count: nil, errors: [])
      @number = indexed_count || csv_info[:csv_data].length
      @exhibit = exhibit
      @csv_file_name = csv_info[:csv_file_name]
      @errors = errors
      mail(to: user.email, subject: 'Document indexing complete')
    end
  end
end
