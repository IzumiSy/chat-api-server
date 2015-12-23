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
    rooms = Room.all
    body rooms.to_json
    status 200
  end

  # TODO
  # - Error handling on validation error in creating a new room
  # - Admin authorization
  post '/api/room/new' do
    param :name, String, required: true
    param :auth_token, String, required: true

    room = Room.create(name: params[:name])
    body room.to_json
    status 202
  end

  # TODO
  # - Implementation
  # - Admin authorization
  delete '/api/room/delete/:id' do
    param :id, String, required: true
    param :auth_token, String, required: true

    status 204
  end

  # Obtains all messages in the room
  get '/api/room/:id' do
    param :id, String, required: true

    room_id = params[:id]
    return if room_id.empty?

    if Room.where(id: room_id).exists?
      room_messages = Room.find(room_id).messages
      body room_messages.to_json
      status 200
    else
      status 404
    end
  end

  # Streaming API subscribe port
  get '/api/room/subscribe/:id', provides: 'text/event-stream' do
    param :id, String, required: true

    client_ip  = request.ip
    channel_id = params[:id]

    if Room.where(id: channel_id).exists?
      p "New suscriber: #{client_ip}"
      run_streaming_loop(channel_id)
    else
      status 404
    end
  end

  # Enters the channel
  post '/api/room/enter' do
    param :user_id, String, required: true
    param :room_id, String, required: true

    # TODO: implementation
  end

  # Leaves the channel
  delete '/api/room/leave' do
    param :user_id, String, required: true
    param :room_id, String, required: true

    # TODO: implementation
  end

  protected

  def run_streaming_loop(channel_id)
    stream :keep_open do |connection|
      loop do
        sleep(1)
      end
    end
  end
end

