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

  def self.broadcastMessage(message_object)
    params = message_object.to_json({
      only: Message::MESSAGE_DATA_LIMITS,
      include: { :user => { only: User::USER_DATA_LIMITS } }
    })
    @io.push :newMessage, params, { channel: message_object.room_id }
  end

  # TODO broadcast message that someone left from the room
  def self.broadcastEnterLog()
    roomUpdate();
  end

  # TODO broaadcast message that someone got in to the room
  def self.broadcastLeaveLog()
    rooUpdate();
  end

  def self.broadcastRoomUpdate()
    params = Room.all.to_json(only: Room::ROOM_DATA_LIMITS)
    @io.push :updateRooms, params
  end
end
