source "https://rubygems.org"
ruby "2.0.0"

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-param', require: 'sinatra/param'
gem 'sinatra-cross_origin'
gem 'sinatra-errorcodes'
gem 'sinatra-rocketio'
gem 'async_sinatra'

gem 'shotgun'
gem 'thin'
gem 'eventmachine'
gem 'hashie', '3.4.4'

gem 'mongoid', '~> 5.0.0'
gem 'mongoid_paranoia'
gem 'bson_ext'

gem 'bcrypt'
gem 'dotenv'

gem 'redis'
gem 'hiredis'

gem 'rake'

gem 'parallel'
gem 'promise'

group :development, :test do
  gem 'rb-readline'
  gem 'pry', require: true
  gem 'pry-byebug'

  gem 'awesome_print'
end

group :test do
  gem 'rspec'
  gem 'mongoid-rspec'
  gem 'rack-test'

  gem 'database_cleaner', git: 'https://github.com/DatabaseCleaner/database_cleaner.git'
  gem 'factory_girl'
  gem 'faker'
end

group :production do
  gem 'rack-ssl-enforcer'
end

