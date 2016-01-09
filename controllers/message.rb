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
    user_id = User.find_by(token: token)

    return if room_id.empty? or content.empty?
    return unless user_id

    if Room.find(room_id)
      message = Message.create(room_id: room_id, user_id: user_id, content: content)
      body message.to_json
      status 202
    else
      body "Room to post not found"
      status 404
    end
  end

  # TODO Implementation
  delete '/api/message/:id' do
    param :room_id, String, required: true
    param :token,   String, required: true

    halt 401 unless
      AuthService.is_logged_in?(params) &&
      AuthService.is_admin?(params)

  end
end

