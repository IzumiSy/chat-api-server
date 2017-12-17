require_relative "../services/message_service"

class Room
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  has_many :users

  LOBBY_ROOM_NAME = "Lobby"

  ROOM_TITLE_LENGTH_MAX = 64
  ROOM_MAX = 100
  ROOM_DATA_LIMITS = [:_id, :name, :users_count]

  field :name, type: String
  field :users_count, type: Integer, default: 0
  field :status, type: Integer, default: 0

  validates :name, presence: true, uniqueness: true,
    absence: false, length: {
      minimum: 0,
      maximum: self::ROOM_TITLE_LENGTH_MAX
    }

  public

  class << self
    def find_lobby
      Mongoid::QueryCache.cache { Room.find_by(name: LOBBY_ROOM_NAME) }
    end

    def fetch_room_data(room_id, fetch_type)
      return case fetch_type
        when :ROOM then
          Room.find_by!(id: room_id).to_json(only: ROOM_DATA_LIMITS)
        when :USER then
          Room.only(:users).find_by!(id: room_id).users.asc(:name).to_json(only: User::USER_DATA_LIMITS)
        else
          raise HTTPError::InternalServerError
        end
    end

    def room_transaction(room_id, user, transaction_type)
      unless user
        raise HTTPError::Unauthorized
      end

      # If "all" is specfied to `room_id` parameter, this function proceeds
      # the transaction that the specified user leaves from the current room.
      is_all_leave_mode = (room_id == "all" && transaction_type == :LEAVE)
      room_id = user.room_id.to_s if is_all_leave_mode

      case transaction_type
      when :ENTER then
        transaction_enter(room_id, user)
      when :LEAVE then
        transaction_leave(room_id, user)
        User.user_deletion(user) if is_all_leave_mode
      else
        raise HTTPError::InternalServerError
      end
    end

    protected

    def transaction_enter(new_room_id, user)
      if user.room
        current_room_id = user.room.id
        Room.decrement_counter(:users_count, current_room_id)
      end

      _room = promise {
        Room.increment_counter(:users_count, new_room_id)
        Mongoid::QueryCache.cache { Room.find_by!(id: new_room_id) }
      }
      _user = promise {
        user.update_attributes!(room_id: new_room_id)
        user
      }

      MessageService.broadcast_enter_msg(_user, _room)
    end

    def transaction_leave(current_room_id, user)
      is_user_exist_in_room =
        current_room_id == user.room_id.to_s ? true : false

      return unless is_user_exist_in_room

      Thread.new { user.update_attributes!(room_id: nil) }
      Room.decrement_counter(:users_count, current_room_id)

      MessageService.broadcast_leave_msg(user)
    end
  end
end

