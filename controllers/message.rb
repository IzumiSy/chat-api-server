require_relative "../services/auth_service"

class MessageRoutes < Sinatra::Base
  include AuthService

  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  post '/api/message/:room_id' do
    param :room_id, String, required: true
    param :content, String, required: true
    param :token,   String, required: true

    halt 401 unless AuthService.is_logged_in?(params)

    room_id = params[:room_id]
    content = params[:content]
    token   = params[:token]
    user    = User.find_by(token: token)

    return if room_id.empty? or content.empty?
    return unless user

    if Room.find(room_id)
      message = Message.create(room_id: room_id, user_id: user.id, content: content)
      body message.to_json(only: Message::MESSAGE_DATA_LIMITS)
      status 202
    else
      body "Room to post not found"
      status 404
    end
  end
end

