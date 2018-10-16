require_relative "../services/message_service"

class Room
  include Mongoid::Document
  include Mongoid::Timestamps

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

