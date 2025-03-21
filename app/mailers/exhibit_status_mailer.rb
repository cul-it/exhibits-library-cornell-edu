# frozen_string_literal: true

# Custom mailer to send email notification to dev team when an exhibit has changed
class ExhibitStatusMailer < ApplicationMailer
  # send email notification when an exhibit is published
  def exhibit_published(exhibit)
    @exhibit = exhibit
    mail(to: 'help-exhibits-library@cornell.edu', subject: 'Online exhibit was published') do |format|
      format.html { render 'spotlight/contact_mailer/exhibit_published' }
    end
  end
end
