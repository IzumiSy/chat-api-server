module RedisService
  def self.connect(options)
    is_takeover = options[:takeover]
    @redis ? is_takeover ? @redis : redis_new() : redis_new()
  end

  def self.set(key, data)
    @redis.set(key, data)
  end

  def self.get(key)
    @redis.get(key)
  end

  def self.instance
    @redis
  end

  protected

  def self.redis_new
    redis = Redis.new(host: ENV["REDIS_IP"], port: ENV["REDIS_PORT"])
    begin
      redis.ping
    rescue Exception => e
      p e.message
    end
    redis
  end
end
