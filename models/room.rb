Mongoid.load!('mongoid.yml')

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
        [ 200, Hash[room.attributes].to_json ]
      when :MSG  then
        # TODO limit data columns to return
        [ 200, room.messages.to_json ]
      when :USER then
        result = []
        room.users.only(:id, :name, :face).each do |u|
          result.push(Hash[u.attributes])
        end
        [ 200, result.to_json ]
      else
        [ 500, {}.to_json ]
      end
  end

  def self.room_transaction(room_id, token, type)
    user = User.find_by(token: token)
    room = Room.only(:users, :users_count).find(room_id)

    unless room
      return [ 404, { status: nil }.to_json ]
    end

    is_user_exist_in_room = room.users.find(user.id) ? true : false

    return case type
      when :ENTER then
        unless is_user_exist_in_room
          if user.room && Room.find(user.room.id).users.find(user.id)
            Room.decrement_counter(:users_count, user.room.id)
          end
          Room.increment_counter(:users_count, room_id)
          user.update_attributes!(room_id: room_id)
        end
        [ 202, { users_count: room.reload.users_count }.to_json ]
      when :LEAVE then
        if is_user_exist_in_room
          Room.decrement_counter(:users_count, user.room.id)
          user.update_attributes!(room_id: nil)
        end
        [ 202, { users_count: room.reload.users_count }.to_json ]
      else
        [ 500, {}.to_json ]
      end
  end
end

