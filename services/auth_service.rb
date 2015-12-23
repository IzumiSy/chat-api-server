require_relative "./redis_service"

module AuthService
  include RedisService

  def self.is_admin?(params)
    token = params[:token]

    user = User.find_by(token: token)
    user.read_attribute(:is_admin)
  end

  def self.is_logged_in?(params)
    token = params[:token]

    RedisService.connect(takeover: true)
    has_session = RedisService.get(token)
    is_user_found = User.where(token: params[:token]).exists?

    if has_session && is_user_found then true else false end
  end
end
