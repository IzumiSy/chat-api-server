require_relative "./base"
require_relative "../services/message_service"

class MessageRoutes < RouteBase
  # Message post API does not check if the room_id valid
  # or not, because it doesnt need to care its existence.
  post '/api/message/:room_id' do
    validates do
      required(:room_id).filled(:str?)
      required(:content).filled(:str?)
    end

    token = is_logged_in?

    room_id = params[:room_id]
    content = params[:content]
    user    = User.find_user_by_token(token)

    raise HTTPError::BadRequest if room_id.empty? or content.empty?
    raise HTTPError::BadRequest unless user

    data = { user_id: user.id, content: content, created_at: Time.now, user: user }
    MessageService.broadcast_message(room_id, data)
  end
end

