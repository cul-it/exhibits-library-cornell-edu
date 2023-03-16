source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'rails', '~> 7.0.4'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.6'
gem 'carrierwave-aws'
gem 'devise'
gem 'devise-guests'
gem 'devise_invitable'
gem 'dotenv-rails'
gem 'font-awesome-rails'
gem 'friendly_id'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'mina' # deployment script generator -- is this used?  should this be used?
gem 'mysql2'
gem 'okcomputer', '~> 1.18'
# Use Puma as the app server
gem 'puma', '< 7'
gem 'riiif'
gem 'rsolr'
gem 'ruby-oembed'
# Use SCSS for stylesheets
gem 'sassc-rails'
gem 'sidekiq', '~> 5.2' # TODO: NEEDS UPGRADE
gem 'sitemap_generator'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 4.2.0'

# Gems manually added to control blacklight and spotlight versions
gem 'blacklight', '~> 7.33.1'
gem 'blacklight-gallery', '~> 4.0'
gem 'blacklight-oembed', '~> 1.0'
gem 'blacklight-spotlight', '~> 3.5'

group :development do
  gem 'better_errors' # add command line in browser when errors
  gem 'binding_of_caller' # deeper stack trace used by better errors
  gem 'letter_opener' # show emails in browser
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'coveralls', require: false
  gem 'factory_bot'
  gem 'factory_bot_rails', require: false
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'webmock'
end

group :development, :test do
  gem 'bixby' # style guide enforcement with rubocop
  gem 'solr_wrapper'
end

group :development, :integration, :test do
  gem 'byebug' # debugging
end
