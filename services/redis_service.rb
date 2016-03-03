module RedisService
  class << self
    def connect(options)
      is_takeover = options[:takeover]
      @redis = is_takeover ?
        @redis ? @redis : redis_new() :
        redis_new()
    end

    def set(key, data)
      redis_ping(@redis)
      @redis.set(key, data)
    end

    def get(key)
      redis_ping(@redis)
      @redis.get(key)
    end

    def delete(key)
      redis_ping(@redis)
      @redis.del(key)
    end

    def instance
      @redis
    end

    protected

    def redis_new
      opts = { host: ENV["REDIS_IP"], port: ENV["REDIS_PORT"] }
      opts.store(:pass, ENV["REDIS_PASS"]) if ENV["REDIS_PASS"]
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
