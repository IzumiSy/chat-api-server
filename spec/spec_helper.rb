ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'json'
require 'pry'
require 'faker'
require 'rack/test'
require 'database_cleaner'
require 'factory_girl'

require_relative '../app.rb'

require_relative './factories/user.rb'
require_relative './factories/room.rb'

module Helpers
  def redis_connect
    @redis = @redis ?
      @redis :
      Redis.new(host: ENV["REDIS_IP"], port: ENV["REDIS_PORT"])
    @redis
  end

  def enter_room(room_id, token)
    user = User.find_by(token: token)
    user.update_attributes!(room_id: room_id)
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
    DatabaseCleaner.orm = "mongoid"

    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.profile_examples = 5
end
