# frozen_string_literal: true

# Preview email on development: 
# http://localhost:9292/rails/mailers/spotlight/indexing_complete_mailer/documents_indexed

module Spotlight
  class IndexingCompleteMailerPreview < ActionMailer::Preview
    def documents_indexed
      csv_info = { csv_data: ['row1', 'row2'], csv_file_name: 'test.csv' }
      exhibit = OpenStruct.new(
      published: true,
      title: 'Example Exhibit',
      subtitle: 'fake exhibit data used for email preview',
      slug: 'example-exhibit'
    )
      user = OpenStruct.new(email: 'test_curator@cornell.edu')
      errors = { 1 => ['Invalid URL'] }
      #errors = {} 
      Spotlight::IndexingCompleteMailer.documents_indexed(csv_info, exhibit, user, indexed_count: 2, errors: errors)
    end
  end
end
