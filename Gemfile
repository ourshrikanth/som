source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development


gem 'devise' #needed for authentication.
gem 'angular-rails-templates'
gem 'angular_rails_csrf'
gem "font-awesome-rails"

gem 'kaminari', '~> 0.16.1' #for pagination, works with array as well. 

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "settingslogic"
gem 'whenever', :require => false #to set up cron Job
gem 'redis-server' #its a dependency of sidekiq to run sidekiq  we need this gem
gem 'sidekiq' #to send email with delayed mailer.
gem 'thin'
# Use Capistrano for deployment
gem 'capistrano', '< 3', group: :development
gem 'rvm-capistrano'
gem 'capistrano-sidekiq' , group: :development
group :test do
  gem 'factory_girl_rails' #rspec related
  gem 'capybara' #rspec related
  gem 'guard-rspec', require: false #rspec related
  gem 'rspec-rails', '~> 3.0'
  gem 'database_cleaner', '~> 1.4.0' #required to clean up the database before every example.
  # gem install rb-fsevent , run this from terminal to run gaurd properly.
end

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
