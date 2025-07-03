# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "pg"
gem "propshaft"
gem "puma", ">= 5.0"
gem "rails", "~> 8.0.1"
gem "sqlite3"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 4.1"
gem "turbo-rails"

gem "bcrypt", "~> 3.1.7"

# Background processing and caching
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "kamal", require: false

# Windows compatibility
gem "tzinfo-data", platforms: %i[windows jruby]

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "dotenv-rails"

  # Testing
  gem "factory_bot_rails"
  gem "faker"
  gem "guard-rspec", require: false
  gem "rails-controller-testing"
  gem "rspec-json_expectations"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "simplecov", require: false

  # Debugging
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Security
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "letter_opener_web"
  # Console
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

gem "redis-session-store", "~> 0.11.5"

gem "activerecord-import"
gem "activeresource"
gem "oj"
gem "puma_worker_killer"
gem "rack-timeout"
gem "sidekiq"
