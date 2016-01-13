class Room
  include Mongoid::Document

  has_many :messages
  has_many :users

  field :name, type: String

  field :messages_count, type: Integer, default: 0
  field :users_count, type: Integer, default: 0

  field :status, type: Integer, default: 0
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true
  validates :name, uniqueness: true

  public

  def self.fetch_room_data(room_id, type)
    room = Room.only(:id, :name, :messages_count, :users_count, :users).find(room_id)
    unless room
      return 404, "Room not found"
    end

    return case type
      when :ROOM then
        [ 200, room.to_json(only: [:_id, :name, :messages_count, :users_count]) ]
      when :MSG  then
        [ 200, room.messages.to_json(only: [:_id, :user_id, :content, :created_at]) ]
      when :USER then
        [ 200, room.users.to_json(only: [:_id, :name, :face]) ]
      else
        [ 500, {}.to_json ]
      end
  end

  # If "all" is specfied to room_id parameter, this function proceeds
  # the transaction that the specified user leaves from the current room.
  def self.room_transaction(room_id, token, type)
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
        [ 202, { users_count: room.reload.users_count }.to_json ]
      else
        [ 500, {}.to_json ]
      end
  end

  protected

  def self.transaction_enter(is_in_room, room_id, user)
    unless is_in_room
      if user.room && Room.find(user.room.id).users.find(user.id)
        Room.decrement_counter(:users_count, user.room.id)
      end
      Room.increment_counter(:users_count, room_id)
      user.update_attributes!(room_id: room_id)
    end
  end

  def self.transaction_leave(is_in_room, room_id, user)
    if is_in_room
      Room.decrement_counter(:users_count, room_id)
      user.update_attributes!(room_id: nil)
    end
  end
end

