require_relative "./redis_service"

module AuthService
  include RedisService

  class << self
    def is_admin?(request)
      auth = Rack::Auth::Basic::Request.new(request.env)
      return nil unless auth.provided?
      return nil unless auth.basic?
      User.is_admin_from_token(auth.params)
    end

    def is_logged_in?(request)
      auth = Rack::Auth::Basic::Request.new(request.env)
      return nil unless auth.provided?
      return nil unless auth.basic?
      User.is_logged_in_from_token(auth.params)
    end
  end
end
