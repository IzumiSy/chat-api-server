require_relative "../../services/auth_service"

module Authorization
  def is_logged_in?
    unless _token = AuthService.is_logged_in?(request)
      raise HTTPError::Unauthorized
    end
    _token
  end

  def is_admin?
    unless _user = AuthService.is_admin?(request)
      raise HTTPError::Unauthorized
    end
    _user
  end
end
