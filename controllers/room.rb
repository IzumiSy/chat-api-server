require_relative "./base"
require_relative "../services/message_service"

class RoomRoutes < RouteBase
  include MessageService

  get '/api/room' do
    # [NOTE] Performance tuning tips
    # - to_json calls find() internally, so it is called here only once.
    # - length property and count() calls a counting method internally
    #   that is relatively slow, so to avoid that overhead, here use JSON conversion.

    is_logged_in?

    room_all =
      Room.all.limit(Room::ROOM_MAX).to_json(only: Room::ROOM_DATA_LIMITS)

    if JSON.parse(room_all).length <= 0
      puts "[INFO] Server seems to have no room. Needed to execute \"rake db:seed_rooms\"."
    end

    body room_all
  end

  post '/api/room/new' do
    param :name,  String, required: true

    is_logged_in?
    is_admin?

    room_name = params[:name]
    if Room.find_by(name: room_name)
      body "Room Name Duplicated"
      halt 409
    end

    room = Room.create(name: room_name)
    body room.to_json(only: Room::ROOM_DATA_LIMITS)
  end

  # TODO Implementation
  delete '/api/room/:id' do
    param :id, String, required: true

    is_logged_in?
    is_admin?
  end

  get '/api/room/:id' do
    param :id, String, required: true

    is_logged_in?

    room_id = params[:id]
    body Room.fetch_room_data(room_id, :ROOM)
  end

  # Wild card implementation for two following ports
  # - /api/room/:id/messages
  # - /api/room/:id/users
  get '/api/room/:id/*' do
    param :id, String, required: true

    is_logged_in?

    target_path = params['splat'].first
    room_id = params[:id]

    body case target_path
      when "messages" then
        Room.fetch_room_data(room_id, :MSG)
      when 'users' then
        Room.fetch_room_data(room_id, :USER)
      else
        raise HTTPError::NotFound
      end
  end

  # This port covers two following ports
  # - /api/room/:id/enter
  # - /api/room/:id/leave
  post '/api/room/:id/*' do
    param :id, String, required: true

    token = is_logged_in?

    target_path = params['splat'].first
    room_id = params[:id]

    case target_path
    when 'enter' then
      Room.room_transaction(room_id, token, :ENTER)
    when 'leave' then
      Room.room_transaction(room_id, token, :LEAVE)
    else
      raise HTTPError::NotFound
    end
  end
end

