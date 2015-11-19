
class RoomRoutes < Sinatra::Base
  helpers Sinatra::Param

  # TODO Error handling on validation error in creating a new room
  post '/api/room/new' do
    param :name, String, required: true
    room = Room.create(name: params[:name])
    body room.to_json
    status 202
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

  # TODO Implementation
  delete '/api/room/delete/:id' do
    param :id, String, required: true
  end
end

