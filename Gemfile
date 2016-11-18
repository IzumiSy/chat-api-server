source "https://rubygems.org"
ruby "1.9.3"

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-param', require: 'sinatra/param'
gem 'sinatra-cross_origin'
gem 'sinatra-errorcodes'
gem 'sinatra-rocketio'

gem 'shotgun'
gem 'thin'

gem 'mongoid', '~> 5.0.0'
gem 'mongoid-paranoia'

gem 'bcrypt'
gem 'dotenv'

gem 'redis'
gem 'hiredis'

gem 'rake'

group :development, :test do
  gem 'pry', require: true
  gem 'pry-debugger'

  gem 'awesome_print'
end

group :test do
  gem 'rspec'
  gem 'mongoid-rspec'
  gem 'rack-test'

  gem 'database_cleaner', github: 'DatabaseCleaner/database_cleaner'
  gem 'factory_girl'
  gem 'faker'
end

group :production do
  gem 'rack-ssl-enforcer'
end

