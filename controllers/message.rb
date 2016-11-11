require_relative "./base"
require_relative "../services/message_service"

class MessageRoutes < RouteBase
  include MessageService

  post '/api/message/:room_id' do
    param :room_id, String, required: true
    param :content, String, required: true

    token = is_logged_in?

    room_id = params[:room_id]
    content = params[:content]
    user    = User.find_by(token: token)

    return if room_id.empty? or content.empty?
    return unless user

    if Room.find(room_id)
      data = { user_id: user.id, content: content, created_at: Time.now, user: user }
      MessageService.broadcast_message(room_id, data)
      status 202
    else
      body "RoomNotFound"
      status 404
    end
  end
end

