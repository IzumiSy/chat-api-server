module MessageService
  @io = Sinatra::RocketIO

  @io.on :connect do |client|

  end

  def self.broadcastMessage(room_id, message)

  end
end
