require 'rspec'
require 'json'
require 'rack/test'
require 'database_cleaner'
require 'factory_girl'
require_relative '../app.rb'

ENV['RACK_ENV'] = 'test'

module Helpers
  def redis_connect
    @redis = @redis ?
      @redis :
      Redis.new(host: ENV["REDIS_IP"], port: ENV["REDIS_PORT"])
    @redis
  end

  # Emulates admin authorize process
  def generate_test_auth_token
    auth_token = Digest::MD5.hexdigest("test")
    @redis.set(ENV["REDIS_IP"], auth_token)
    auth_token
  end
end

RSpec.configure do |config|
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods
  include Helpers

  def app()
    Application.new
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.profile_examples = 10
end
