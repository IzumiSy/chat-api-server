module MessageService
  @@connections = []

  def self.addConnection(connection)
    @@connections << connection
  end

  def self.getConnections
    @@connections
  end
end
