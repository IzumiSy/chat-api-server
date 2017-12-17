require_relative "../../services/auth_service"

module Authorization
  def is_logged_in?
    if User.find(session[:user_id])
      true
    else
      raise HTTPError::Unauthorized
    end
  end

  def is_admin?
    unless _user = AuthService.is_admin?(request)
      raise HTTPError::Unauthorized
    end
    _user
  end
end
