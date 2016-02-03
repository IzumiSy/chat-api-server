module RedisService
  class << self
    def self.connect(options)
      is_takeover = options[:takeover]
      @redis = is_takeover ?
        @redis ? @redis : redis_new() :
        redis_new()
    end

    def self.set(key, data)
      redis_ping(@redis)
      @redis.set(key, data)
    end

    def self.get(key)
      redis_ping(@redis)
      @redis.get(key)
    end

    def self.delete(key)
      redis_ping(@redis)
      @redis.del(key)
    end

    def self.instance
      @redis
    end

    protected

    def self.redis_new
      redis = Redis.new(host: ENV["REDIS_IP"], port: ENV["REDIS_PORT"])
      redis_ping(redis)
      redis
    end

    def self.redis_ping(redis)
      begin
        redis.ping
      rescue Exception => e
        p e.message
      end
    end
  end
end
