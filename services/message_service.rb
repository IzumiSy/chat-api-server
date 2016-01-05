module MessageService
  @@connections = []

  def self.addConnection(connection)
    @@connections << connection
  end

  def self.getConnections
    @@connections
  end

  def self.broadcastMessage(message)
    @@connections.each do |connection|
      connection << "data: #{message}\n\n"
    end
  end
end
