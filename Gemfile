source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.6'
gem 'dotenv-deployment'
gem 'dotenv-rails'

# rails related dependencies
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'mysql2'
gem 'puma', '~> 3.0'
gem 'sass-rails', '>= 3.2'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'uglifier', '>= 1.3.0'

# spotlight related dependencies
gem 'blacklight', ' ~> 6.14.0'
gem 'blacklight-spotlight', '~> 1.4.0'
gem 'blacklight-gallery', '>= 0.3.0'
gem 'blacklight-oembed', '>= 0.1.0'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'devise'
gem 'devise-guests', '~> 0.5'
gem 'devise_invitable'
gem 'font-awesome-sass', '~> 4.5.0'
gem 'friendly_id', github: 'norman/friendly_id'
gem 'openseadragon'
gem 'riiif'
gem 'rsolr', '~> 1.0'
gem 'sitemap_generator'


gem 'mina'
gem 'jquery-rails'



# ruby "2.5.3"

# gem 'therubyracer', platforms: :ruby
# gem 'redis', '~> 3.0'
# gem 'bcrypt', '~> 3.1.7'

# gem 'capistrano-rails', group: :development

group :development, :integration, :test do
  # gem 'byebug', platform: :mri
  gem 'byebug'
  # gem 'capybara'
  gem 'coveralls', require: false
  # gem 'database_cleaner'
  # gem 'factory_bot_rails', '~> 4.4', require: false
  # gem 'faker'
  gem 'listen'
  # gem 'listen', '~> 3.0.5'
  # gem 'rails-controller-testing'
  # gem 'rspec-rails'
  # gem 'rspec-activemodel-mocks'
  gem 'rubocop'
  gem 'rubocop-checkstyle_formatter', require: false
  # gem 'rubocop', '~> 0.48.1', require: false
  # gem 'rubocop-checkstyle_formatter', '~> 0.4.0', require: false
  gem 'solr_wrapper', '>= 0.3'
end

group :development, :integration do
  gem 'better_errors' # add command line in browser when errors
  gem 'binding_of_caller' # deeper stack trace used by better errors
  # gem 'bixby', '~> 1.0.0' # style guide enforcement with rubocop
  gem 'spring' # Spring speeds up development by keeping your application running in the background.
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '~> 3.0' # access to IRB console on exception pages
  gem 'xray-rails'
end

group :test do
  gem 'rspec-rails', '~> 3.1'
  # gem 'rubocop-rspec', '~> 1.15', '>= 1.15.1'
  gem 'sqlite3'
end


# tmp pin of autoprefixer to avoid nodes version error
gem 'autoprefixer-rails', '8.5.2'
