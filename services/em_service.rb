module EmService
  class << self
    def ensure_em
      unless
        EventMachine.reactor_running? &&
        EventMachine.reactor_thread.alive?
        Thread.new { EventMachine.run }
        Sleep1
      end
    end
  end
end
