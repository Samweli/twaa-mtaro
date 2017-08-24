source 'http://rubygems.org'
ruby "2.2.3"

gem 'rails', '~> 3.2.13'

gem 'arel'
gem 'devise', '2.2.2'
gem 'geokit'
gem 'haml', '~> 3.2.0.alpha'
gem 'haml-rails'
gem 'pg'
gem 'rack-contrib'
gem 'execjs'
gem 'therubyracer'
gem 'jquery-rails'
gem 'recaptcha', :require => 'recaptcha/rails'
gem 'kaminari'
gem 'omniauth-facebook'
gem 'rest-client'
gem 'browser'
gem 'twilio-ruby', '4.13.0'
gem 'social-share-button', '~> 0.1.6'
gem 'google-analytics-rails', '1.1.1'

platforms :jruby do
  gem 'jruby-openssl'
  gem 'therubyrhino'
end

platforms :ruby_18 do
  gem 'fastercsv'
end

group :assets do
  gem 'uglifier'
end

group :production do
  gem 'passenger'
end

group :development do
  gem 'nifty-generators'
  gem 'faker'
end

group :test do
  gem 'simplecov'
#  gem 'sqlite3'
  gem 'webmock'
  gem "mocha"
end
