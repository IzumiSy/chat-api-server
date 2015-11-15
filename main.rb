require 'rubygems'
require 'sinatra/base'
require 'sinatra/param'
require 'json'
require 'rack'
require 'config'

require_relative 'models/user'

class UserRoutes < Sinatra::Base
  helpers Sinatra::Param

  get '/api/users' do
    status 200
  end

  post '/api/user/signup' do
    param :name,  String, required: true
    param :email, String, required: true

    User.create([
      { name:  params[:name]  },
      { email: params[:email] }
    ])

    status 202
  end

  post '/api/user/signin' do
    param :name,  String, required: true
    param :email, String, required: true

    # Log-in transaction

    status 202
  end
end

class Application < Sinatra::Base
  configure do
    set :raise_errors, true
    set :show_exceptions, false
  end

  enable :logging

  use UserRoutes
end
