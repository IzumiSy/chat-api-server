module MessageService
  @io = Sinatra::RocketIO

  @io.on :connect do |client|
    puts "[INFO] New client: #{client.session}, #{client.address}"
  end

  def self.broadcastMessage(room_id, user_id, message)
    params = { message: message, user_id: user_id }
    @io.push :newMessage, params, { channel: room_id }
  end
end
