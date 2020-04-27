require_relative "./base"
require_relative "../services/message_service"

class MessageRoutes < RouteBase
  namespace '/api/message' do
    must_be_logged_in!

    # Message post API does not check if the room_id valid
    # or not, because it doesnt need to care its existence.
    post '/:room_id' do
      validates do
        required(:room_id).filled(:str?)
        required(:content).filled(:str?)
      end

      room_id = params[:room_id]
      content = params[:content]

      raise HTTPError::BadRequest if room_id.empty? or content.empty?

      data = { user_id: current_user.id, content: content, created_at: Time.now, user: current_user }
      MessageService.broadcast_message(room_id, data)

      empty_json!
    end
  end
end

