# frozen_string_literal: true

# Preview (feedback form) email on development: 
# http://localhost:9292/rails/mailers/spotlight/contact_mailer/report_problem

module Spotlight
  class ContactMailerPreview < ActionMailer::Preview
    def report_problem
      contact_form = OpenStruct.new(
        name: 'Jane Doe',
        email: 'janedoe@example.com',
        message: 'This is a test message from the feedback form that was sent by a patron who wanted to ask questions about the exhibit they were viewing.',
        headers: { to: 'help-exhibits-library@cornell.edu', subject: 'Feedback from Jane Doe' },
        request: OpenStruct.new(remote_ip: '127.0.0.1', user_agent: 'Mozilla/5.0'),
        current_exhibit: OpenStruct.new(title: 'Example Exhibit'),
        current_url: 'http://localhost:9292/example-exhibit'
      )
      Spotlight::ContactMailer.report_problem(contact_form)
    end
  end
end
