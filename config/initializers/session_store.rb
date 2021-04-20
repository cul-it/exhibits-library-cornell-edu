### CUSTOMIZATION (jcolt) part of basic Rails app setup to add cookie key

# Be sure to restart your server when you modify this file.
Rails.application.config.session_store :cookie_store, key: '_exhibits_session'
