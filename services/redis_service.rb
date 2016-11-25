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

    protected

    def _connection
      @redis ? @redis : redis_new()
    end

    def redis_new
      opts = { host: ENV["REDIS_IP"], port: ENV["REDIS_PORT"] }
      opts.store(:password, ENV["REDIS_PASS"]) if ENV["REDIS_PASS"]
      redis = Redis.new(opts)
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
