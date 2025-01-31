# frozen_string_literal: true

module Spotlight
  ##
  # Notify the curator that we're finished processing a
  # batch upload
  class IndexingCompleteMailer < ActionMailer::Base
    def documents_indexed(csv_data, exhibit, user, csv_file_name, indexed_count: nil, errors: [])
      @number = indexed_count || csv_data.length
      @exhibit = exhibit
      @csv_file_name = csv_file_name
      @errors = errors
      mail(to: user.email, subject: 'Document indexing complete')
    end
  end
end