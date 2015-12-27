require_relative '../services/auth_service'

class RoomRoutes < Sinatra::Base
  include AuthService

  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  get '/api/room' do
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    rooms = Room.all
    body rooms.to_json
    status 200
  end

  # TODO
  # - Error handling on validation error in creating a new room
  # - Admin authorization
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

  # TODO
  # - Implementation
  # - Admin authorization
  delete '/api/room/delete/:id' do
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
    stat_code, data = fetch_room_data(room_id, :ROOM)

    body data
    status stat_code
  end

  get '/api/room/:id/*' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    target_path = params['splat'].first
    room_id = params[:id]

    case target_path
    when "messages" then
      stat_code, data = fetch_room_data(room_id, :MSG)
    when 'users' then
      stat_code, data = fetch_room_data(room_id, :USER)
    else
      stat_code, data = [ 404, {}.to_json ]
    end

    body data
    status stat_code
  end

  # Enters the room
  post '/api/room/enter' do
    param :user_id, String, required: true
    param :room_id, String, required: true
    param :token,   String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    user_id = params[:user_id];
    room_id = params[:room_id];
    p "(#{user_id}) entered to room(#{room_id})"

    # TODO: implementation
  end

  # Leaves the room
  delete '/api/room/leave' do
    param :user_id, String, required: true
    param :room_id, String, required: true
    param :token,   String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    user_id = params[:user_id];
    room_id = params[:room_id];
    p "(#{user_id}) leaved from room(#{room_id})"

    # TODO: implementation
  end

  # Streaming API subscribe port
  get '/api/room/subscribe/:id', provides: 'text/event-stream' do
    param :id,    String, required: true
    param :token, String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    client_ip  = request.ip
    room_id = params[:id]

    if Room.where(id: room_id).exists?
      p "New suscriber: #{client_ip}"
      run_streaming_loop(room_id)
    else
      body "Room not found"
      status 404
    end
  end

  protected

  def fetch_room_data(room_id, type)
    unless Room.where(id: room_id).exists?
      return 404, "Room not found"
    end

    room = Room.find(room_id)

    return case type
      when :ROOM then [ 200, room.to_json ]
      when :MSG  then [ 200, room.messages.to_json ]
      when :USER then [ 200, room.users.to_json ]
      else [ 500, {}.to_json ]
      end
  end

  def run_streaming_loop(room_id)
    stream :keep_open do |connection|
      loop do
        sleep(1)
      end
    end
  end
end

