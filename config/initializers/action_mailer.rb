Exhibits::Application.config.action_mailer.default_url_options = { host: ENV['EMAIL_URL'] }
Exhibits::Application.config.action_mailer.default_options = { from: ENV['EMAIL_FROM'] }
