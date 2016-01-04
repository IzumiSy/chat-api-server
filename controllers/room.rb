require_relative '../services/auth_service'
require_relative '../services/message_service'

class RoomRoutes < Sinatra::Base
  include AuthService
  include MessageService

  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  get '/api/room' do
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    if Room.count <= 0
      logger.info "[INFO] Server seems to have no room. Needed to execute \"rake db:seed_rooms\"."
    end

    # Use map instead of select querying
    rooms = []
    Room.only(:id, :name, :messages_count, :users_count).all.map do |room|
      rooms.push(Hash[room.attributes])
    end

    body rooms.to_json
    status 200
  end

  post '/api/room/new' do
    param :name,  String, required: true
    param :token, String, required: true

    halt 401 unless
      AuthService.is_logged_in?(params) &&
      AuthService.is_admin?(params)

    room = Room.create(name: params[:name])
    body room.to_json
    status 202
  end

  # Streaming API subscribe port
  get '/api/room/:id/subscribe' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    client_ip  = request.ip
    room = Room.find(params[:id])
    token = params[:token]

    if room && room == User.find_by(token: token).room
      logger.info "[INFO] New suscriber: #{client_ip}"
      stream :keep_open do |connection|
        MessageService.addConnection(connection)
      end
    else
      body "Room not found"
      status 404
    end
  end

  # TODO Implementation
  delete '/api/room/:id' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless
      AuthSertice.is_logged_in?(params) &&
      AuthService.is_admin?(params)

    status 204
  end

  get '/api/room/:id' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    room_id = params[:id]
    stat_code, data = Room.fetch_room_data(room_id, :ROOM)

    body data
    status stat_code
  end

  # Wild card implementation for two following ports
  # - /api/room/:id/messages
  # - /api/room/:id/users
  get '/api/room/:id/*' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    target_path = params['splat'].first
    room_id = params[:id]

    case target_path
    when "messages" then
      stat_code, data = Room.fetch_room_data(room_id, :MSG)
    when 'users' then
      stat_code, data = Room.fetch_room_data(room_id, :USER)
    else
      stat_code, data = [ 404, {}.to_json ]
    end

    body data
    status stat_code
  end

  # This port covers two following ports
  # - /api/room/:id/enter
  # - /api/room/:id/leave
  post '/api/room/:id/*' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    target_path = params['splat'].first
    room_id = params[:id]
    token = params[:token]

    case target_path
    when 'enter' then
      stat_code, data = Room.room_transaction(room_id, token, :ENTER)
    when 'leave' then
      stat_code, data = Room.room_transaction(room_id, token, :LEAVE)
    else
      stat_code, data = [ 404, {}.to_json ]
    end

    body data
    status stat_code
  end
end

