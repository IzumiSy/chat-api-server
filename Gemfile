source "https://rubygems.org"
ruby "2.6.6"

gem 'sinatra', '~> 2.0.2'
gem 'sinatra-errorcodes'
gem 'sinatra-rocketio'
gem 'async_sinatra'

gem 'dry-validation'

gem 'shotgun'
gem 'thin'

gem 'mongoid'

gem 'sysrandom'
gem 'bcrypt'
gem 'dotenv'

gem 'dalli'
gem 'rack-cache'
gem 'rack-health'
gem 'rack-cors'
gem 'rack-contrib'

gem 'rake'

gem 'parallel'
gem 'promise'

# For security reasons
gem 'rack', '>= 2.0.6'

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

  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'faker'
end

group :production do
  gem 'rack-ssl-enforcer'
end
