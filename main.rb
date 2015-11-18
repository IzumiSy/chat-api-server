require 'sinatra/base'
require 'sinatra/param'

require_relative 'models/room'
require_relative 'models/message'

class RoomRoutes < Sinatra::Base
  helpers Sinatra::Param

  post '/api/room/new' do

  end

  delete '/api/room/delete/:id' do

  end
end

class MeesageRoutes < Sinatra::Bas
  helpers Sinatra::Param

  post 'api/message/post' do

  end
end

class BasicRoutes < Sinatra::Base
  get '/api/ping' do
    body 'pong'
  end
end

class Application < Sinatra::Base
  configure do
    set :raise_errors, true
    set :show_exceptions, false
  end

  enable :logging

  use BasicRoutes
  use RoomRoutes
  use MessageRoutes
end
