require 'sinatra'
require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/cross_origin'
require 'sinatra/rocketio'
require 'sinatra/errorcodes'

require 'digest/md5'

require 'mongoid'
require 'mongoid/paranoia'

require 'redis'
require 'securerandom'

require 'dotenv'

require 'rack-ssl-enforcer'

require_relative 'controllers/basic'
require_relative 'controllers/room'
require_relative 'controllers/message'
require_relative 'controllers/user'

require_relative 'models/room'
require_relative 'models/user'

Dotenv.load
Mongoid.load!('mongoid.yml', ENV['RACK_ENV'])

class Application < Sinatra::Base
  register Sinatra::RocketIO

  configure do
    set :cometio, timeout: 360, post_interval: 1
    set :rocketio, websocket: false, comet: true
  end

  not_found do
    raise HTTPError::NotFound
  end

  use BasicRoutes
  use UserRoutes
  use RoomRoutes
  use MessageRoutes

  use Rack::SslEnforcer, except_environments: ['development', 'test']

  options "*" do
    response.headers["Access-Control-Allow-Headers"] =
      "Authorization"
    200
  end
end
