require_relative "../services/message_service"

class Room
  include Mongoid::Document
  include MessageService

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
      room_id = user.room.id if is_all_leave_mode

      room = Room.only(:users, :users_count).find(room_id)
      unless room
        return [ 404, "Room not found" ]
      end

      is_user_exist_in_room = room.users.find(user.id) ? true : false

      return case type
        when :ENTER then
          transaction_enter(is_user_exist_in_room, room_id, user)
          [ 202, { users_count: room.reload.users_count }.to_json ]
        when :LEAVE then
          transaction_leave(is_user_exist_in_room, room_id, user)
          User.user_deletion(user) if is_all_leave_mode
          [ 202, { users_count: room.reload.users_count }.to_json ]
        else
          [ 500, {}.to_json ]
        end
    end

    protected

    def transaction_enter(is_in_room, room_id, user)
      unless is_in_room
        if user.room && Room.find(user.room.id).users.find(user.id)
          Room.decrement_counter(:users_count, user.room.id)
        end
        Room.increment_counter(:users_count, room_id)
        user.update_attributes!(room_id: room_id)
        MessageService.broadcast_enter_msg(user, room_id)
      end
    end

    def transaction_leave(is_in_room, room_id, user)
      if is_in_room
        Room.decrement_counter(:users_count, room_id)
        user.update_attributes!(room_id: nil)
        MessageService.broadcast_leave_msg(user, room_id)
      end
    end
  end
end

