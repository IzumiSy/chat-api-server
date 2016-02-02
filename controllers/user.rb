require_relative '../services/auth_service'

class UserRoutes < Sinatra::Base
  include AuthService

  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  # This user creation port does not need to use slice
  # to limite user data to return.
  post '/api/user/new' do
    param :name, String, required: true

    client_ip = request.ip
    client_name = params[:name]

    if client_ip.empty? || client_name.empty?
      status 400
      return
    end

    if User.find_by(name: client_name)
      body "Duplicated user name"
      status 409
      return
    end

    user = User.new(name: client_name, ip: client_ip)
    user.save!

    body user.to_json
    status 202
  end

  get '/api/user/:id' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    user_id = params[:id]
    stat_code, data = User.fetch_user_data(user_id, :USER)

    body data
    status stat_code
  end

  get '/api/user/:id/room' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    user_id = params[:id]
    stat_code, data = User.fetch_user_data(user_id, :ROOM)

    body data
    status stat_code
  end

  # TODO: Implementation
  put '/api/user/:id' do
    param :id,    String, required: true
    param :data,  Hash, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

  end

  # TODO: Implementation
  delete '/api/user/:id' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

  end
end
