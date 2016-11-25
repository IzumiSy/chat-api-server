require_relative "./redis_service"

module AuthService
  include RedisService

  class << self
    def is_admin?(request)
      auth = Rack::Auth::Basic::Request.new(request.env)
      return nil unless auth.provided?
      return nil unless auth.basic?

      token = auth.params
      user = User.find_user_by_token(token)
      user.read_attribute(:is_admin)
    end

    def is_logged_in?(request)
      auth = Rack::Auth::Basic::Request.new(request.env)
      return nil unless auth.provided?
      return nil unless auth.basic?

      token = auth.params
      RedisService.connect(takeover: true)
      has_session = RedisService.get(token)
      # is_user_found = User.find_user_by_token(token)

      if has_session then token else nil end
    end
  end
end
