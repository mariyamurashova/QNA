# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.1'

gem 'rails', '~> 7.1.1'
gem 'sprockets-rails'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'bootsnap', require: false
gem 'slim-rails'
gem 'devise'
gem "sass-rails"
gem 'cocooned'
gem 'octokit'
gem 'decent_exposure', '~> 3.0'
gem 'aws-sdk-s3', require: false
gem 'gon'
gem 'bootstrap'
gem 'rack-cors', :require => 'rack/cors' 
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
gem 'omniauth-rails_csrf_protection'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'oj'
gem 'sidekiq', '< 7'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'pg_search'
gem 'mini_racer'
gem 'base64', '~> 0.1.1'
gem 'redis', '~>4.7.1'
gem 'redis-client'
gem 'unicorn'
gem 'redis-rails'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'byebug', '~> 11.1'
  gem 'letter_opener'

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'capybara-email'
end

