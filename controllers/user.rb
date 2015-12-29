require_relative '../services/auth_service'

class UserRoutes < Sinatra::Base
  include AuthService

  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  post '/api/user/new' do
    param :name, String, required: true

    client_ip = request.ip
    client_name = params[:name]

    if client_ip.empty? || client_name.empty?
      status 400
      return
    end

    user = User.new(name: client_name, ip: client_ip)
    user.save!

    body user.to_json
    status 202
  end

  post '/api/user/usable' do
    param :name, String, required: true

    provided_name = params[:name]
    is_name_available = User.where(name: provided_name).exists?

    result = { status: !is_name_available }
    body result.to_json
    status 200
  end

  # A port to fetch self data only with user token
  # To fetch other users' data, use id specified port instead.
  get '/api/user' do
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    user = User.find_by(token: token)

    body
      if user
        status 200
        user.to_json
      else
        status 404
        {}.to_json
      end
  end

  get '/api/user/:id' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    user_id = params[:id]
    stat_code, data = fetch_user_data(user_id, :USER)

    body data
    status stat_code
  end

  get '/api/user/:id/room' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    user_id = params[:id]
    stat_code, data = fetch_user_data(user_id, :ROOM)

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
    param :data,  Hash, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

  end

  protected

  def fetch_user_data(user_id, type)
    unless user = User.find_by(id: user_id)
      return 404, "User not found"
    end

    return case type
      when :USER then [ 200, user.to_json ]
      when :ROOM then [ 200, user.room.to_json ]
      else [ 500, {}.to_json ]
      end
  end
end
