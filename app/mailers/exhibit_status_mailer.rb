# frozen_string_literal: true

# Custom mailer to send email notification to dev team when an exhibit has changed
class ExhibitStatusMailer < ApplicationMailer
  def send_exhibit_status_email(exhibit)
    @exhibit = exhibit
    subject = @exhibit.published ? 'Online exhibit was published' : 'Online exhibit was unpublished'

    begin
      mail(to: 'help-exhibits-library@cornell.edu', subject: subject) do |format|
        format.html { render 'exhibit_status_mailer/exhibit_publish_status' }
      end
    rescue StandardError => e
      Rails.logger.error("**** EMAIL FAILURE on notification '#{subject}': #{e.message}")
    end
  end
end
