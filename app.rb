require 'sinatra'
require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/cross_origin'
require 'sinatra/rocketio'

require 'newrelic_rpm'

require 'digest/md5'

require 'mongoid'
require 'redis'
require 'securerandom'

require 'dotenv'
require 'config'

require 'pry'

require_relative 'controllers/basic'
require_relative 'controllers/room'
require_relative 'controllers/message'
require_relative 'controllers/user'

require_relative 'models/room'
require_relative 'models/user'

Dotenv.load

Mongoid.load!('mongoid.yml')
Mongoid.configure do |config|
  if ENV['RACK_ENV'] == 'production'
    config.clients['default']['uri'] = ENV['MONGOLAB_URI']
  end
end

class Application < Sinatra::Base
  register Sinatra::RocketIO

  configure do
    set :raise_errors, true
    set :show_exceptions, false

    set :cometio, timeout: 360, post_interval: 1
    set :rocketio, websocket: false, comet: true
  end

  not_found do
    status 404
    body "Port not found"
  end

  use BasicRoutes
  use UserRoutes
  use RoomRoutes
  use MessageRoutes

  options "*" do
    response.headers["Access-Control-Allow-Headers"] =
      "Authorization"
    200
  end
end
