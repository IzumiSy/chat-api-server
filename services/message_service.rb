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
    params = {
      _id: message_object.id,
      content: message_object.content,
      user_id: message_object.user_id,
      created_at: message_object.created_at
    }
    @io.push :newMessage, params, { channel: message_object.room_id }
  end
end
