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
    User.trigger_disconnection_resolver(client)
  end

  @io.on :error do |client|
    puts "[INFO] Client error: #{client.session}, #{client.address}"
    user = User.find_by(session: client.session)
    User.user_deletion(user)
  end

  # Pseudo enum
  module SYSTEM_LOG_TYPE
    USER_ENTER = 0
    USER_LEAVE = 1
  end

  class << self
    def broadcast_message(room_id, params)
      @io.push :newMessage, params.to_json, { channel: room_id }
    end

    def broadcast_enter_msg(user, room_id)
      broadcast_system_log(SYSTEM_LOG_TYPE::USER_ENTER, user.name, room_id)
      broadcast_members_update(room_id)
      broadcast_room_update()
    end

    def broadcast_leave_msg(user, room_id)
      broadcast_system_log(SYSTEM_LOG_TYPE::USER_LEAVE, user.name, room_id)
      broadcast_members_update(room_id)
      broadcast_room_update()
    end

    private

    def broadcast_system_log(type, user_name, room_id)
      case type
      when SYSTEM_LOG_TYPE::USER_ENTER then
        # @io.push userEnter, user_name, { channel: room_id }
      when SYSTEM_LOG_TYPE::USER_LEAVE then
        # @io.push userLeave, user_name, { channel: room_id }
      else
        # TODO kinda exception handling is needed here
      end
    end

    def broadcast_room_update()
      params = Room.all.to_json(only: Room::ROOM_DATA_LIMITS)
      @io.push :updateRooms, params
    end

    def broadcast_members_update(room_id)
      room = Room.find(room_id)
      users = room.users.asc(:name).to_json(only: User::USER_DATA_LIMITS)
      @io.push :updateMembers, users, { channel: room_id }
    end

    def resolve_disconnected_users(user_id, new_session)
      user = User.find(user_id)
      return unless user
      if user.session == new_session
        User.user_deletion(user)
      end
    end
  end
end
