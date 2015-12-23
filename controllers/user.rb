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

    return if client_ip.empty? or client_name.empty?

    user = User.create(name: client_name, ip: client_ip)
    body user.to_json
    status 202
  end

  get '/api/user/usable/:name' do
    param :name, String, required: true

    provided_name = params[:name]
    is_name_available = User.where(name: provided_name).exists?

    result = { status: !is_name_available }
    body result.to_json
    status 200
  end

  get 'api/user/:id' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    user_id = params[:id]
    data = fetch_user_data(user_id, :USER)

    if data
      body data
      status 200
    else
      status 404
    end
  end

  # TODO: Implementation
  put 'api/user/:id' do
    param :id,    String, required: true
    param :data,  Hash, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

  end

  # TODO: Implementation
  delete 'api/user/:id' do
    param :id,    String, required: true
    param :data,  Hash, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

  end

  get 'api/user/:id/room' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    user_id = params[:id]
    data = fetch_user_data(user_id, :ROOM)

    if data
      body data
      status 200
    else
      status 404
    end
  end

  protected

  def fetch_user_data(user_id, type)
    return nil if user_id.empty?

    return nil unless User.where(id: user_id).exists?
    user = User.find(user_id)

    return case
      when type == :USER
        user.to_json
      when type == :ROOM
        user.room.to_json
      else
        nil
      end
  end
end
