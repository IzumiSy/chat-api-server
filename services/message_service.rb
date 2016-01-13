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
end
