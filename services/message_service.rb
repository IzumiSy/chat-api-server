module MessageService
  @io = Sinatra::RocketIO

  @io.on :connect do |client|
    puts "[INFO] New client: #{client.session}, #{client.address}"
  end

  @io.on :disconnect do |client|
    puts "[INFO] Client diconnected: #{client.session}, #{client.address}"
  end

  @io.on :error do |client|
    puts "[INFO] Client error: #{client.session}, #{client.address}"
  end

  def self.broadcast_message(message_object)
    params = message_object.to_json({
      only: Message::MESSAGE_DATA_LIMITS,
      include: { :user => { only: User::USER_DATA_LIMITS } }
    })
    @io.push :newMessage, params, { channel: message_object.room_id }
  end

  # Pseudo enum
  module SYSTEM_LOG_TYPE
    USER_ENTER = 0
    USER_LEAVE = 1
  end

  def self.broadcastEnterLog(user)
    broadcastSystemLog(SYSTEM_LOG_TYPE::USER_ENTER, user)
    broadcastRoomUpdate()
  end

  def self.broadcastLeaveLog(user)
    broadcastSystemLog(SYSTEM_LOG_TYPE::USER_LEAVE, user)
    broadcastRoomUpdate()
  end

  private

  def self.broadcastSystemLog(type, user)
    case type
    when SYSTEM_LOG_TYPE::USER_ENTER then
      # @io.push :userEnter
    when SYSTEM_LOG_TYPE::USER_LEAVE then
      # @io.push :userLeave
    else
      # TODO kinda exception handling is needed here
    end
  end

  def self.broadcastRoomUpdate()
    params = Room.all.to_json(only: Room::ROOM_DATA_LIMITS)
    @io.push :updateRooms, params
  end
end
