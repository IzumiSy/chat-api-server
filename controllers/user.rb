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
      status 400
      return
    end

    # If there is an user who has the same IP when the new user attempts to enter a channel,
    # just oust him/her out of the channel and let the new user enter to there.
    if user = User.find_by(ip: client_ip)
      User.resolve_disconnected_users(user.id, user.session)
    end

    create_user_param = {
      name: client_name, ip: client_ip
    }

    if (params[:face])
      create_user_param[:face] = params[:user]
    end

    if lobby_room = Room.find_by(name: "Lobby")
      create_user_param[:room_id] = lobby_room.id
    else
      body "No lobby room"
      status 500
      return
    end

    user = User.new(create_user_param)
    unless user.save
      body "Duplicated user name"
      status 409
      return
    end

    # If room_id is specified, it means that user enters into
    # the room with room_id, so it makes a broadcasting.
    if lobby_room
      EmService.defer do
        Room.increment_counter(:users_count, lobby_room.id)
        MessageService.broadcast_enter_msg(user, lobby_room)
      end
    end

    body user.to_json(only: User::USER_DATA_LIMITS.dup << :token << :room_id)
    status 202
  end

  get '/api/user/duplicate/:name' do
    param :name, String, required: true

    status = {
      status: !User.find_by(name: params[:name]) ? true : false
    }

    body status.to_json
    status 200
  end

  get '/api/user/:id' do
    param :id, String, required: true

    is_logged_in?

    user_id = params[:id]
    stat_code, data = User.fetch_user_data(user_id, :USER)

    body data
    status stat_code
  end

  get '/api/user/:id/room' do
    param :id, String, required: true

    is_logged_in?

    user_id = params[:id]
    stat_code, data = User.fetch_user_data(user_id, :ROOM)

    body data
    status stat_code
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
    user = User.find(user_id);
    user.update_attributes!(data);
    user.save

    body user.to_json(only: User::USER_DATA_LIMITS)
    status 202
  end

  # TODO: Implementation
  delete '/api/user/:id' do
    param :id, String, required: true

    is_logged_in?
  end
end
