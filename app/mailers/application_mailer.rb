class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM']
  layout 'mailer'
end
