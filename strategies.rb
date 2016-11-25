require 'warden'

Warden::Strategies.add(:user) do
  def valid?
    auth = Rack::Auth::Basic::Request.new(request.env)
    auth.provided? and auth.basic?
  end

  def authenticate!
    auth = Rack::Auth::Basic::Request.new(request.env)
    RedisService.connect(takeover: true)
    token = auth.params
    has_session = RedisService.get(token)
    # is_user_found = User.find_user_by_token(token)
    if has_session then token else nil end
  end
end

Warden::Strategies.add(:admin) do
  def valid?
    auth = Rack::Auth::Basic::Request.new(request.env)
    auth.provided? and auth.basic?
  end

  def authenticate!
    auth = Rack::Auth::Basic::Request.new(request.env)
    token = auth.params
    user = User.find_user_by_token(token)
    user.read_attribute(:is_admin)
  end
end

