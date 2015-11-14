require 'rubygems'
require 'sinatra/base'
require 'sinatra/param'
require 'json'
require 'rack'
require 'mongoid'
require 'config'

class UserRoutes < Sinatra::Base
  helpers Sinatra::Param

  get '/user' do
    "user"
  end

  post '/user/signup' do
    "signup"
  end

  post '/user/signin' do
    "signin"
  end
end

class Application < Sinatra::Base
  enable :logging

  use UserRoutes
end
