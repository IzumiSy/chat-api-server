require_relative "../services/auth_service"

class MessageRoutes < Sinatra::Base
  include AuthService

  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  post '/api/message' do
    param :room_id, String, required: true
    param :content, String, required: true
    param :token,   String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

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

