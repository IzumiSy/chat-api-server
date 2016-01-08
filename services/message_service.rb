module MessageService
  @io = Sinatra::RocketIO

  @io.on :connect do |client|
    puts "[INFO] New client: #{client.session}, #{client.address}"
  end

  def self.broadcastMessage(room_id, message)
    @io.push :newMessage, message, channel: room_id
  end
end
