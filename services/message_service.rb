module MessageService
  @clients = []
  @io = Sinatra::RocketIO

  @io.on :connect do |client|
    logger.info "New client connected: #{client.session}, #{client.address}"
    @clients << client
  end

  def self.broadcastMessage(room_id, message)

  end
end
