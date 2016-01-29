module MessageService
  @io = Sinatra::RocketIO

  @io.on :connect do |client|
    puts "[INFO] New client: #{client.session}, #{client.address}"
    user = User.find_by(ip: client.address)
    if user
      user.update_attributes!(session: client.session)
    end
  end

  @io.on :disconnect do |client|
    puts "[INFO] Client diconnected: #{client.session}, #{client.address}"
  end

  @io.on :error do |client|
    puts "[INFO] Client error: #{client.session}, #{client.address}"
  end

  def self.broadcast_message(room_id, params)
    @io.push :newMessage, params.to_json, { channel: room_id }
  end

  # Pseudo enum
  module SYSTEM_LOG_TYPE
    USER_ENTER = 0
    USER_LEAVE = 1
  end

  def self.broadcast_enter_msg(user, room_id)
    broadcast_system_log(SYSTEM_LOG_TYPE::USER_ENTER, user.name, room_id)
    broadcast_members_update(room_id)
    broadcast_room_update()
  end

  def self.broadcast_leave_msg(user, room_id)
    broadcast_system_log(SYSTEM_LOG_TYPE::USER_LEAVE, user.name, room_id)
    broadcast_members_update(room_id)
    broadcast_room_update()
  end

  private

  def self.broadcast_system_log(type, user_name, room_id)
    case type
    when SYSTEM_LOG_TYPE::USER_ENTER then
      # @io.push userEnter, user_name, { channel: room_id }
    when SYSTEM_LOG_TYPE::USER_LEAVE then
      # @io.push userLeave, user_name, { channel: room_id }
    else
      # TODO kinda exception handling is needed here
    end
  end

  def self.broadcast_room_update()
    params = Room.all.to_json(only: Room::ROOM_DATA_LIMITS)
    @io.push :updateRooms, params
  end

  def self.broadcast_members_update(room_id)
    room = Room.find(room_id)
    users = room.users.asc(:name).to_json(only: User::USER_DATA_LIMITS)
    @io.push :updateMembers, users, { channel: room_id }
  end
end
