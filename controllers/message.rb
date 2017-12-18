require_relative "./base"
require_relative "../services/message_service"

class MessageRoutes < RouteBase
  before do
    raise HTTPError::BadRequest unless is_logged_in?
  end

  # Message post API does not check if the room_id valid
  # or not, because it doesnt need to care its existence.
  post '/api/message/:room_id' do
    validates do
      required(:room_id).filled(:str?)
      required(:content).filled(:str?)
    end

    room_id = params[:room_id]
    content = params[:content]

    raise HTTPError::BadRequest if room_id.empty? or content.empty?

    data = { user_id: user.id, content: content, created_at: Time.now, user: current_user }
    MessageService.broadcast_message(room_id, data)
  end
end

