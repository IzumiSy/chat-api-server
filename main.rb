require 'sinatra/base'
require 'sinatra/param'
require 'sinatra-websocket'

require_relative 'models/room'
require_relative 'models/message'

set :server, 'thin'
set :socket, []

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

class MessageRoutes < Sinatra::Base
  helpers Sinatra::Param

  post '/api/message' do
    param :room_id, String, required: true
    param :content, String, required: true
    room_id = params[:room_id]
    content = params[:content]
    return if room_id.empty? or content.empty?
    if Room.where(id: room_id).exists?
      message = Message.create(room_id: room_id, content: content)
      body message.to_json
      status 202
    else
      status 404
    end
  end
end

class BasicRoutes < Sinatra::Base
  get '/api/ping' do
    body 'pong'
  end
end

class Application < Sinatra::Base
  configure do
    set :raise_errors, true
    set :show_exceptions, false
  end

  enable :logging

  use BasicRoutes
  use RoomRoutes
  use MessageRoutes
end
