Rails.application.configure do
  config.action_mailer.default_url_options = { host: ENV['EMAIL_URL'] }
  config.action_mailer.default_options = { from: ENV['EMAIL_FROM'] }
  config.action_mailer.asset_host = ENV['EMAIL_URL']
end
