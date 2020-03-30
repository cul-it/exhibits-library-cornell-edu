source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-deployment'
gem 'dotenv-rails'
gem 'rails', '~> 5.1.6'                   # 5.1.7    5.2.4.2

# rails related dependencies
gem 'coffee-rails', '~> 4.2'              # 4.2.2    4.2.2
gem 'jbuilder', '~> 2.5'                  # 2.10.0   2.10.0
gem 'puma', '~> 3.12'                     # 3.12.4   3.12.4
gem 'sass-rails', '>= 3.2'                # 5.0.7    5.1.0
gem 'turbolinks', '~> 5'                  # 5.2.0    5.2.1
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'uglifier', '>= 1.3.0'                # 4.1.20   4.2.0

# spotlight related dependencies          # cornell   spotlight
gem 'blacklight', ' ~> 6.14.0'            # 6.14.1    6.23.0
gem 'blacklight-gallery', '>= 0.3.0'      # 0.12.0    0.12.0
gem 'blacklight-oembed', '>= 0.1.0'       # 0.3.0     0.3.0
gem 'blacklight-spotlight', '= 2.0.0'     # 1.5.1     2.0.0
gem 'bootstrap-sass', '~> 3.3.6'          # 3.3.7     3.4.1
gem 'devise'                              # 4.7.1     4.7.1
gem 'devise-guests', '~> 0.5'             # 0.6.1     0.7.0
gem 'devise_invitable'                    # 1.7.5     1.7.5
gem 'friendly_id', '~> 5.3'               #           5.3.0
gem 'jquery-rails'                        # 4.3.5     4.3.5
gem 'openseadragon' # js lib for displaying tiling images  # 0.5.0
gem 'riiif'                               # 1.7.1     1.7.1
gem 'rsolr', '~> 1.0'                     # 1.1.2     2.3.0
gem 'sitemap_generator'                   # 6.0.1     6.1.0

# additional app dependencies based on our specific setup
gem 'carrierwave-aws'
gem 'font-awesome-sass', '~> 4.5.0'
gem 'mina' # deployment script generator -- is this used?  should this be used?
gem 'mysql2'
gem 'sidekiq', '~> 5.2'                   # 5.2.8

group :development, :integration, :test do
  gem 'byebug' # debugging
  gem 'listen' # listens for changes to files to allow for auto-reload during development
  # gem 'database_cleaner'
end

group :development do
  gem 'solr_wrapper', '>= 0.3' # start solr based on .solr_wrapper.yml

  # gem 'spring-watcher-listen', '~> 2.0.0' # makes Spring watch filesystem for changes using Listen rather than polling
end

group :development, :integration do
  gem 'better_errors' # add command line in browser when errors
  gem 'binding_of_caller' # deeper stack trace used by better errors
  gem 'spring' # Spring speeds up development by keeping your application running in the background.
  gem 'web-console', '~> 3.0' # access to IRB console on exception pages
  gem 'xray-rails' # overlay showing which files are contributing to the UI
end

group :development, :test do
  gem 'bixby', '~> 1.0.0' # style guide enforcement with rubocop
  gem 'rubocop-checkstyle_formatter', require: false
end

group :test do
  gem 'coveralls', require: false
  gem 'rspec-rails', '~> 3.1'
  gem 'sqlite3'

  # gem 'capybara'
  # gem 'factory_bot_rails', '~> 4.4', require: false
  # gem 'faker'
  # gem 'rails-controller-testing'
  # gem 'rspec-rails'
  # gem 'rspec-activemodel-mocks'
end

# tmp pins for incompatibilities
gem 'autoprefixer-rails', '8.5.2' # avoid nodes version error
gem 'sprockets', '3.7.2' # avoid err working with font-awesome 4.5 - corrected in 5.12

# ruby "2.5.3"
# gem 'therubyracer', platforms: :ruby
# gem 'redis', '~> 3.0'
# gem 'bcrypt', '~> 3.1.7'
# gem 'capistrano-rails', group: :development
