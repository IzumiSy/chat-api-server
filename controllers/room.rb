
class RoomRoutes < Sinatra::Base
  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  # TODO Error handling on validation error in creating a new room
  post '/api/room/new' do
    param :name, String, required: true

    room = Room.create(name: params[:name])
    body room.to_json
    status 202
  end

  # TODO Implementation
  delete '/api/room/delete/:id' do
    param :id, String, required: true
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

  protected

  def run_streaming_loop(channel_id)
    stream :keep_open do |connection|
      loop do
        sleep(1)
      end
    end
  end
end

