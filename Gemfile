source 'http://rubygems.org'
ruby "2.2.3"

gem 'rails', '~> 3.2.13'

gem 'active_model_serializers', '0.9.2'
gem 'arel'
gem 'browser'
gem 'devise', '2.2.2'
gem 'execjs'
gem 'geokit'
gem 'google-analytics-rails', '1.1.1'
gem 'haml', '~> 3.2.0.alpha'
gem 'haml-rails'
gem 'jquery-rails'
gem 'kaminari'
gem 'omniauth-facebook'
gem "paranoia", "~> 1.0"
gem 'pg', '~> 0.11'
gem 'rack-contrib', '1.8.0'
gem 'rack-cors', :require => 'rack/cors'
gem 'ransack'
gem 'recaptcha', :require => 'recaptcha/rails'
gem 'rest-client'
gem 'social-share-button', '~> 0.1.6'
gem 'test-unit', '~> 3.0'
gem 'therubyracer'
gem 'twilio-ruby', '4.13.0'
gem 'faker'


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
end

group :test do
  gem "shoulda"
  gem 'simplecov'
#  gem 'sqlite3'
  gem 'webmock'
  gem "mocha"
end
