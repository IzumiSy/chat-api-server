module RedisService
  class << self
    def connect(options)
      is_takeover = options[:takeover]
      @redis = is_takeover ? _connection() : redis_new()
    end

    def set(key, data)
      _connection().set(key, data)
    end

    def get(key)
      _connection().get(key)
    end

    def delete(key)
      _connection().del(key)
    end

    def flush
      _connection.script(:flush)
    end

    protected

    def _connection
      @redis ? @redis : redis_new()
    end

    def redis_new
      redis = Redis.new
      redis_ping(redis)
      redis
    end

    def redis_ping(redis)
      begin
        redis.ping
      rescue Exception => e
        p e.message
      end
    end
  end
end
