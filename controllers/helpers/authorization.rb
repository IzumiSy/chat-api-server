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
    user = User.find(session[:user_id])
    if user && user.is_admin?
      true
    else
      raise HTTPError::Unauthorized
    end
  end
end
