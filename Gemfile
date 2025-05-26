source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
gem "propshaft"
gem "mysql2"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", "~> 2.6.1", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem "sentry-ruby"
gem "sentry-rails"

gem "sendgrid-ruby"
gem "redis"
gem "posthog-ruby"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "letter_opener"
  gem "lookbook", ">= 2.3.9"
  gem "listen"
  gem "actioncable"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "sqlite3"
end

gem "devise", "~> 4.9"
gem 'omniauth'
gem 'omniauth-apple'
gem 'omniauth-google-oauth2'

gem "will_paginate"
gem "rspec"

gem "dotenv", groups: [:development, :test]

gem "aws-sdk-s3"
gem "active_storage_validations"
gem "psych", "~> 5.1.0"
gem "tailwindcss-ruby", "3.4.17"
gem "tailwindcss-rails", "3.3.1"

gem 'sidekiq'
gem 'connection_pool'

# For caching
gem 'hiredis'

gem "view_component"