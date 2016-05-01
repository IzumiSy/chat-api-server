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

    # If there is an user who has the same IP when the new user attempts to enter a channel,
    # just oust him/her out of the channel and let the new user enter to there.
    if user = User.find_by(ip: client_ip)
      User.resolve_disconnected_users(user.id, user.session)
    end

    user = User.new(name: client_name, ip: client_ip)
    user.save!

    body user.to_json
    status 202
  end

  get '/api/user/duplicate/:name' do
    param :name, String, required: true

    status = {
      status: !User.find_by(name: params[:name]) ? true : false
    }.to_json

    body status
    status 200
  end

  get '/api/user/:id' do
    param :id, String, required: true

    halt 401 unless _token = AuthService.is_logged_in?(request)

    user_id = params[:id]
    stat_code, data = User.fetch_user_data(user_id, :USER)

    body data
    status stat_code
  end

  get '/api/user/:id/room' do
    param :id, String, required: true

    halt 401 unless _token = AuthService.is_logged_in?(request)

    user_id = params[:id]
    stat_code, data = User.fetch_user_data(user_id, :ROOM)

    body data
    status stat_code
  end

  # TODO Need to write test here
  # Notes: somehow PUT is not working well in this port
  # so I decided to use POST instead for updating user's data
  post '/api/user/:id' do
    param :id,    String, required: true
    param :data,  Hash,   required: true

    halt 401 unless _token = AuthService.is_logged_in?(request)

    user_id = params[:id]
    data = params[:data]
    user = User.find(user_id);
    user.update_attributes!(data);
    user.save

    body user.to_json(only: User::USER_DATA_LIMITS)
    status 202
  end

  # TODO: Implementation
  delete '/api/user/:id' do
    param :id, String, required: true

    halt 401 unless _token = AuthService.is_logged_in?(request)

  end
end
