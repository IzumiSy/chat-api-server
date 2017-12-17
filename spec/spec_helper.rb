ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'json'
require 'faker'
require 'rack/test'
require 'mongoid-rspec'
require 'database_cleaner'
require 'factory_girl'

require_relative '../app.rb'

require_relative './factories/user.rb'
require_relative './factories/room.rb'

module Helpers
  def enter_room(room_id, user)
    user = User.find(user.id)
    user.update_attributes!(room_id: room_id)
  end
end

RSpec.configure do |config|
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods
  include Helpers

  config.include RSpec::Matchers
  config.include Mongoid::Matchers

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
