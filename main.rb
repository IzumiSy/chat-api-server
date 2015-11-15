require 'sinatra/base'
require 'sinatra/param'
require 'json'
require 'config'
require 'pry'

require_relative 'models/user'

class UserRoutes < Sinatra::Base
  helpers Sinatra::Param

  get '/api/users/:id' do
    param :id, String, require: true
    User.find(params[:id])
  end

  post '/api/user/signup' do
    param :name,  String, required: true
    param :email, String, required: true

    user = User.create(name:  params[:name], email: params[:email])

    body user.to_json
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
