require_relative "./base"
require_relative "../services/message_service"

class RoomRoutes < RouteBase
  before do
    raise HTTPError::BadRequest unless is_logged_in?
  end

  get '/api/room' do
    # [NOTE] Performance tuning tips
    # - to_json calls find() internally, so it is called here only once.
    # - length property and count() calls a counting method internally
    #   that is relatively slow, so to avoid that overhead, here use JSON conversion.
    room_all = Mongoid::QueryCache.cache {
      Room.all.limit(Room::ROOM_MAX).to_json(only: Room::ROOM_DATA_LIMITS)
    }

    if JSON.parse(room_all).length <= 0
      puts "[INFO] Server seems to have no room. Needed to execute \"rake db:seed_rooms\"."
    end

    body room_all
  end

  post '/api/room/new' do
    validates do
      required("name").filled(:str?)
    end

    raise HTTPError::Unauthorized unless is_admin?

    room_name = params[:name]
    room = Room.new(name: room_name)
    room.save!

    body room.to_json(only: Room::ROOM_DATA_LIMITS)
  end

  get '/api/room/:id' do
    validates do
      required(:id).filled(:str?)
    end

    room_id = params[:id]
    body Room.fetch_room_data(room_id, :ROOM)
  end

  get '/api/room/:id/messages' do
    validates do
      required("id").filled(:str?)
    end

    room_id = params[:id]
    Room.fetch_room_data(room_id, :MSG)
  end

  get '/api/room/:id/users' do
    validates do
      required("id").filled(:str?)
    end

    room_id = params[:id]
    Room.fetch_room_data(room_id, :USER)
  end

  post '/api/room/:id/enter' do
    validates do
      required("id").filled(:str?)
    end

    raise HTTPError::BadRequest unless is_logged_in?

    room_id = params[:id]
    Room.transaction_enter(room_id, current_user)
  end

  post '/api/room/:id/leave' do
    validates do
      required("id").filled(:str?)
    end

    room_id = params[:id]

    binding.pry
    if room_id == 'all'
      User.user_deletion(current_user)
    else
      Room.transaction_leave(room_id, current_user)
    end
  end
end

