# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::ContactMailer
module PrependedMailers::ContactMailer
  # new method to send email notification when an exhibit is published
  def exhibit_published(exhibit)
    @exhibit = exhibit
    mail(to: 'help-exhibits-library@cornell.edu', subject: 'Online exhibit was published') do |format|
      format.html { render 'spotlight/contact_mailer/exhibit_published' }
    end
  end
end
