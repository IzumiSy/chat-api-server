require_relative "./base"
require_relative "../services/message_service"

class RoomRoutes < RouteBase
  namespace '/api/rooms' do
    must_be_logged_in!

    get '/' do
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

    get '/:id' do
      validates do
        required(:id).filled(:str?)
      end

      room_id = params[:id]

      Room.find_by!(id: room_id).to_json(only: ROOM_DATA_LIMITS)
    end

    get '/:id/users' do
      validates do
        required("id").filled(:str?)
      end

      room_id = params[:id]

      Room.only(:users).find_by!(id: room_id)
        .users.asc(:name).to_json(only: User::USER_DATA_LIMITS)
    end

    post '/:id/enter' do
      validates do
        required("id").filled(:str?)
      end

      room_id = params[:id]
      Room.transaction_enter(room_id, current_user)

      empty_json!
    end

    post '/:id/leave' do
      validates do
        required("id").filled(:str?)
      end

      room_id = params[:id]

      if room_id == 'all'
        User.user_deletion(current_user)
      else
        Room.transaction_leave(room_id, current_user)
      end

      empty_json!
    end

    post '/new' do
      must_be_logged_in_as_admin!

      validates do
        required("name").filled(:str?)
      end

      room_name = params[:name]
      room = Room.new(name: room_name)
      room.save!

      room.to_json(only: Room::ROOM_DATA_LIMITS)
    end
  end
end

