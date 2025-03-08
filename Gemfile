source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.4"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem 'aasm'
gem 'redis'


gem "devise"
gem "cocoon"

group :development, :test do
  gem "debug"
  gem 'rspec-rails', '~> 6.0.0'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'database_cleaner-active_record'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false  # Optional: for LCOV format output
end

group :development do
  gem "web-console"
  gem 'rerun'
  gem 'foreman', '~> 0.87.2'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "tailwindcss-rails", "~> 3.0"
