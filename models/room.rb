require_relative "../services/message_service"
require_relative "../services/em_service"

class Room
  include Mongoid::Document
  include MessageService
  include EmService

  has_many :users

  ROOM_MAX = 200
  ROOM_DATA_LIMITS = [:_id, :name, :messages_count, :users_count]

  field :name, type: String

  field :messages_count, type: Integer, default: 0
  field :users_count, type: Integer, default: 0

  field :status, type: Integer, default: 0
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true
  validates :name, uniqueness: true

  public

  class << self
    def fetch_room_data(room_id, type)
      room = Room.find(room_id)
      unless room
        return 404, "Room not found"
      end

      return case type
        when :ROOM then
          [ 200, room.to_json(only: ROOM_DATA_LIMITS) ]
        when :USER then
          [ 200, room.users.asc(:name).to_json(only: User::USER_DATA_LIMITS) ]
        else
          [ 500, {}.to_json ]
        end
    end

    # If "all" is specfied to room_id parameter, this function proceeds
    # the transaction that the specified user leaves from the current room.
    def room_transaction(room_id, token, type)
      unless user = User.find_by(token: token)
        return [ 500, "Invalid token" ]
      end

      is_all_leave_mode = (room_id == "all" && type == :LEAVE)
      room_id = user.room_id if is_all_leave_mode

      return case type
        when :ENTER then
          transaction_enter(room_id, user)
          [ 202, { status: "ok" }.to_json ]
        when :LEAVE then
          transaction_leave(room_id, user)
          User.user_deletion(user) if is_all_leave_mode
          [ 202, { status: "ok" }.to_json ]
        else
          [ 500, { status: "Internal error"}.to_json ]
        end
    end

    protected

    def transaction_enter(new_room_id, user)
      EM::defer do
        if user.room
          current_room_id = user.room.id
          Room.decrement_counter(:users_count, current_room_id)
        end
        Room.increment_counter(:users_count, new_room_id)
        MessageService.broadcast_enter_msg(user, new_room_id)
      end
      user.update_attributes!(room_id: new_room_id)
    end

    def transaction_leave(current_room_id, user)
      is_user_exist_in_room =
        current_room_id == user.room_id ? true : false
      return unless is_user_exist_in_room
      EM::defer do
        Room.decrement_counter(:users_count, current_room_id)
        MessageService.broadcast_leave_msg(user, current_room_id)
      end
      user.update_attributes!(room_id: nil)
    end
  end
end

