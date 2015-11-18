require 'sinatra/base'
require 'sinatra/param'

require_relative 'models/room'
require_relative 'models/message'

class RoomRoutes < Sinatra::Base
  helpers Sinatra::Param

  post '/api/room/new' do
    param :name, String, required: true
    room = Room.create(name: params[:name])
    body room.to_json
    status 202
  end

  delete '/api/room/delete/:id' do
    param :id, String, required: true
  end
end

class MessageRoutes < Sinatra::Base
  helpers Sinatra::Param

  post 'api/message/post' do
    param :channel_id, String, required: true
    param :content,    String, required: true
    channel_id = params[:channel_id]
    content = params[:content]
    return if channel_id.empty? or content.empty?
=begin
    if Room.where(_id: channel_id).exists?
      message = Message.create(channel_id: channel_id, content: content)
      body message.to_body
      status 202
    end
=end
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
