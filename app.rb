require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/cross_origin'

require 'mongoid'
require 'redis'
require 'securerandom'

require_relative 'controllers/basic'
require_relative 'controllers/room'
require_relative 'controllers/message'
require_relative 'controllers/user'

require_relative 'models/room'
require_relative 'models/message'
require_relative 'models/user'

class Application < Sinatra::Base
  configure do
    set :raise_errors, true
    set :show_exceptions, false

    set :server, 'thin'
    set :socket, []

    enable :logging
    enable :cross_origin
  end

  use BasicRoutes
  use UserRoutes
  use RoomRoutes
  use MessageRoutes
end
