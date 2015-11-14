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
  end

  post '/user/signup' do
  end

  post '/user/signin' do
  end
end

class IndexRoute < Sinatra::Base
  get '/' do
    "index"
  end
end

class ChatAPIServer < Sinatra::Base
  enable :logging

  use IndexRoute
  use UserRoutes
end
