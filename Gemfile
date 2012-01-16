source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'

gem 'arel'
gem 'devise'
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

group :test do
  gem 'simplecov'
#  gem 'sqlite3'
  gem 'webmock'
end
