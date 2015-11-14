require 'rubygems'
require 'sinatra/base'
require 'sinatra/param'
require 'json'
require 'rack'
require 'mongoid'
require 'config'

require_relative 'models/user'

class UserRoutes < Sinatra::Base
  helpers Sinatra::Param

  get '/user' do
    halt 200
  end

  post '/user/signup' do
    halt 200
  end

  post '/user/signin' do
    halt 200
  end
end

class IndexRoute < Sinatra::Base
  get '/' do
    halt 200
  end
end

class Application < Sinatra::Base
  enable :logging

  use IndexRoute
  use UserRoutes
end
