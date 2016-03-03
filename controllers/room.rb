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
    halt 401 unless _token = AuthService.is_logged_in?(request)

    if Room.count <= 0
      puts "[INFO] Server seems to have no room. Needed to execute \"rake db:seed_rooms\"."
    end

    body Room.all.to_json(only: Room::ROOM_DATA_LIMITS)
    status 200
  end

  post '/api/room/new' do
    param :name,  String, required: true

    halt 401 unless
      AuthService.is_logged_in?(request) &&
      AuthService.is_admin?(request)

    room_name = params[:name]
    if Room.find_by(name: room_name)
      body "Duplicated room name"
      status 409
      return
    end

    room = Room.create(name: room_name)
    body room.to_json(only: Room::ROOM_DATA_LIMITS)
    status 202
  end

  # TODO Implementation
  delete '/api/room/:id' do
    param :id,    String, required: true

    halt 401 unless
      AuthSertice.is_logged_in?(request) &&
      AuthService.is_admin?(request)

    status 204
  end

  get '/api/room/:id' do
    param :id,    String, required: true

    halt 401 unless _token = AuthService.is_logged_in?(request)

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

    halt 401 unless _token = AuthService.is_logged_in?(request)

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

    halt 401 unless token = AuthService.is_logged_in?(request)

    target_path = params['splat'].first
    room_id = params[:id]

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

