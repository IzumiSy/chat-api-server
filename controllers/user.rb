require_relative "./base"
require_relative "../services/em_service"

class UserRoutes < RouteBase
  include EmService

  # This user creation port does not need to use slice
  # to limite user data to return.
  post '/api/user/new' do
    param :name, String, required: true
    param :face, String

    client_ip = request.ip
    client_name = params[:name]

    if client_ip.empty? || client_name.empty?
      raise HTTPError::BadRequest
    end

    create_user_param = {
      name: client_name, ip: client_ip
    }

    if (params[:face])
      create_user_param[:face] = params[:face]
    end

    # If there is an user who has the same IP when the new user attempts to enter a channel,
    # just oust him/her out of the channel and let the new user enter to there.
    if user = User.find_user_by_ip(client_ip)
      User.resolve_disconnected_users(user.id, user.session)
    end

    unless lobby_room = Room.find_lobby()
      raise HTTPError::InternalServerError, "No Lobby Room"
    end

    _create_new_user = promise {
      create_user_param[:room_id] = lobby_room.id
      user = User.new(create_user_param)
      user.save!
      user
    }
    _increment_lobby = promise {
      Room.increment_counter(:users_count, lobby_room.id)
      lobby_room
    }

    # If room_id is specified, it means that user enters into
    # the room with room_id, so it makes a broadcasting.
    if lobby_room
      MessageService.broadcast_enter_msg(_create_new_user, _increment_lobby)
    end

    body user.to_json(only: User::USER_DATA_LIMITS.dup << :token << :room_id)
  end

  get '/api/user/duplicate/:name' do
    param :name, String, required: true

    _status = {
      status: User.get_name_availability(params[:name])
    }.to_json

    body _status
  end

  get '/api/user/:id' do
    param :id, String, required: true

    is_logged_in?

    user_id = params[:id]
    body User.fetch_user_data(user_id, :USER)
  end

  get '/api/user/:id/room' do
    param :id, String, required: true

    is_logged_in?

    user_id = params[:id]
    body User.fetch_user_data(user_id, :ROOM)
  end

  # TODO Need to write test here
  # Notes: somehow PUT is not working well in this port
  # so I decided to use POST instead for updating user's data
  post '/api/user/:id' do
    param :id,    String, required: true
    param :data,  Hash,   required: true

    is_logged_in?

    user_id = params[:id]
    data = params[:data]
    user = User.find_by!(id: user_id);
    user.update_attributes!(data);
    user.save

    body user.to_json(only: User::USER_DATA_LIMITS)
  end

  # TODO: need test
  delete '/api/user/:id' do
    param :id, String, required: true

    is_logged_in?

    user_id = params[:id]
    user = User.find_by!(id: user_id);

    User.user_deletion(user)
  end
end
