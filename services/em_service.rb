require 'eventmachine'

module EmService
  class << self
    def ensure_em
      unless
        EventMachine.reactor_running? &&
        EventMachine.reactor_thread.alive?
        Thread.new { EventMachine.run }
        Sleep 1
      end
    end

    def defer(&block)
      ensure_em
      EM::defer(block)
    end
  end
end
