require 'rspec'
require 'json'
require 'rack/test'
require 'database_cleaner'
require_relative '../app.rb'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  include Rack::Test::Methods

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
