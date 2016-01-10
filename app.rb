require 'sinatra'
require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/cross_origin'
require 'sinatra/rocketio'

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
require_relative 'models/message'
require_relative 'models/user'

Dotenv.load
Mongoid.load!('mongoid.yml')

class Application < Sinatra::Base
  register Sinatra::RocketIO

  configure do
    set :raise_errors, true
    set :show_exceptions, false

    set :cometio, timeout: 120, allow_crossdomain: true
    set :websocketio, port: 3001
    set :rocketio, websocket: true, comet: true
  end

  not_found do
    status 404
    body "Port not found"
  end

  use BasicRoutes
  use UserRoutes
  use RoomRoutes
  use MessageRoutes
end
