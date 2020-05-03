require_relative "./base"
require_relative "../services/message_service"

class MessageRoutes < RouteBase
  # Message post API does not check if the room_id valid
  # or not, because it doesnt need to care its existence.
  post '/api/message/:room_id' do
    must_be_logged_in!

    validates do
      schema do
        required(:room_id).filled(:string)
        required(:content).filled(:string)
      end
    end

    room_id = params[:room_id]
    content = params[:content]

    data = { user_id: current_user.id, content: content, created_at: Time.now, user: current_user }
    MessageService.broadcast_message(room_id, data)

    empty_json!
  end
end

