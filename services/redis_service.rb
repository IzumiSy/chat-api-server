module RedisService
  def self.connect
    unless @redis
      @redis = Redis.new(
        host: ENV["REDIS_IP"],
        port: ENV["REDIS_PORT"]
      )
      begin
        @redis.ping
      rescue Exception => e
        p e.message
      end
    end
    @redis
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
end