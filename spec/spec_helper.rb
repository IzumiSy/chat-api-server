require 'rspec'
require 'rack/test'
require_relative '../main.rb'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  include Rack::Test::Methods

  def app()
    Application.new
  end

  config.warnings = true
  config.profile_examples = 10
end
