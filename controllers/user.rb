require_relative "./base"

class UserRoutes < RouteBase
  # This user creation port does not need to use slice
  # to limite user data to return.
  post '/api/user/new' do
    validates do
      required("name").filled(:str?)
      optional("face")
    end

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

    user = _create_new_user
    login(user)

    body user.to_json(only: User::USER_DATA_LIMITS.dup << :room_id)
  end

  namespace '/api/user' do
    must_be_logged_in!

    get '/:id' do
      validates do
        required("id").filled
      end

      user_id = params[:id]
      body User.fetch_user_data(user_id, :USER)
    end

    get '/:id/room' do
      validates do
        required("id").filled
      end

      user_id = params[:id]
      body User.fetch_user_data(user_id, :ROOM)
    end

    # TODO Need to write test here
    # Notes: somehow PUT is not working well in this port
    # so I decided to use POST instead for updating user's data
    post '/:id' do
      validates do
        required("id").filled(:str?)
        required("data").filled(:hash?)
      end

      user_id = params[:id]
      data = params[:data]
      user = User.find_by!(id: user_id);
      user.update_attributes!(data);
      user.save

      body user.to_json(only: User::USER_DATA_LIMITS)
    end

    # TODO: need test
    delete '/:id' do
      validates do
        required("id").filled
      end

      user_id = params[:id]
      user = User.find_by!(id: user_id);

      User.user_deletion(user)

      empty_json!
    end

  end
end
