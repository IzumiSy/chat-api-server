require_relative "./redis_service"

module AuthService
  class << self
    def is_admin?(request)
      token = parse_token(request)
      User.is_admin_from_token(token)
    end

    def is_logged_in?(request)
      token = parse_token(request)
      User.is_logged_in_from_token(token)
    end

    private

    def parse_token(request)
      auth = Rack::Auth::Basic::Request.new(request.env)
      return nil unless auth.provided?
      return nil unless auth.basic?
      auth.params
    end
  end
end
