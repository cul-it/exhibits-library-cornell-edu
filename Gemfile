source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.7'

# rubocop:disable Bundler/OrderedGems
## Gems adds by `rails new`
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.8'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '< 7'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 4.2.0'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] ### OVERRIDE - defined below to expand availability
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

## Gems manually added to control blacklight and spotlight versions
gem 'blacklight', '= 7.19.0'
gem 'blacklight-spotlight', '~> 3.3'
# gem 'blacklight-spotlight', github: 'projectblacklight/spotlight', branch: 'master'

## Gems added by spotlight installation process
group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
end

# TODO: Check if this be removed after ror upgrade
# Added to fix "already initialized constant errors" with net/protocol: https://github.com/ruby/net-imap/issues/16
gem "net-http"
gem 'sprockets', '~> 3.0'

gem 'rsolr', '>= 1.0', '< 3'
gem 'bootstrap', '~> 4.6'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'jquery-rails'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'friendly_id'
gem 'sitemap_generator'
gem 'blacklight-gallery', '~> 3.0'
gem 'blacklight-oembed', '~> 1.0'
# rubocop:enable Bundler/OrderedGems

## Gems added for application customization
# support for .env file
gem 'dotenv-rails'

# spotlight related dependencies
# gem 'blacklight-advanced_search'
# gem 'blacklight-heatmaps'
# gem 'blacklight-range_limit', '~> 6.0'
gem 'devise_invitable'
gem 'riiif'

# additional app dependencies based on our specific setup
gem 'carrierwave-aws'
gem 'font-awesome-rails'
gem 'mina' # deployment script generator -- is this used?  should this be used?
gem 'mysql2'
gem 'okcomputer', '~> 1.18'
gem 'ruby-oembed'
gem 'sidekiq', '~> 5.2'

group :development, :integration, :test do
  gem 'byebug' # debugging
  # gem 'database_cleaner'
end

group :development, :integration do
  gem 'xray-rails' # overlay showing which files are contributing to the UI
end

group :development do
  gem 'better_errors' # add command line in browser when errors
  gem 'binding_of_caller' # deeper stack trace used by better errors
  gem 'letter_opener' # show emails in browser
end

group :development, :test do
  gem 'bixby', '~> 3.0' # style guide enforcement with rubocop
  gem 'rubocop-checkstyle_formatter', require: false
end

group :test do
  gem 'capybara-screenshot', '~> 1.0'
  gem 'coveralls', require: false
  gem 'factory_bot', '~> 4.4'
  gem 'factory_bot_rails', '~> 4.4', require: false
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'rspec-its', '~> 1.1'
  gem 'rspec-rails', '~> 3.1'
  gem 'rspec_junit_formatter'
  gem 'webdrivers', '~> 4.4'
  gem 'webmock'
end
