require 'sinatra/base'
require 'sinatra/param'

require_relative 'models/user'

class UserRoutes < Sinatra::Base
  helpers Sinatra::Param

  get '/api/users/:id' do
    param :id, String, require: true
    user = User.find(params[:id])
    body user.to_json
    status 200
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
  use UserRoutes
end
