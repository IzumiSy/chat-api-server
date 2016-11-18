require_relative "../services/message_service"
require_relative "../services/em_service"

class Room
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include MessageService
  include EmService

  has_many :users

  ROOM_MAX = 200
  ROOM_DATA_LIMITS = [:_id, :name, :users_count]

  field :name, type: String
  field :users_count, type: Integer, default: 0
  field :status, type: Integer, default: 0

  validates :name, presence: true, uniqueness: true

  public

  class << self
    def fetch_room_data(room_id, fetch_type)
      unless room = Room.find(room_id)
        raise HTTPError::NotFound
      end

      return case fetch_type
        when :ROOM then
          room.to_json(only: ROOM_DATA_LIMITS)
        when :USER then
          room.users.asc(:name).to_json(only: User::USER_DATA_LIMITS)
        else
          raise HTTPError::InternalServerError
        end
    end

    def room_transaction(room_id, token, transaction_type)
      unless user = User.find_by(token: token)
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
      unless room = Room.find(new_room_id)
        raise HTTPError::NotFound
      end

      EmService.defer do
        if user.room
          current_room_id = user.room.id
          Room.decrement_counter(:users_count, current_room_id)
        end
        Room.increment_counter(:users_count, new_room_id)
        MessageService.broadcast_enter_msg(user, room)
      end

      user.update_attributes!(room_id: new_room_id)
    end

    def transaction_leave(current_room_id, user)
      is_user_exist_in_room =
        current_room_id == user.room_id.to_s ? true : false

      unless is_user_exist_in_room
        raise HTTPError::NotFound
      end

      EmService.defer do
        Room.decrement_counter(:users_count, current_room_id)
        MessageService.broadcast_leave_msg(user)
      end

      user.update_attributes!(room_id: nil)
    end
  end
end

