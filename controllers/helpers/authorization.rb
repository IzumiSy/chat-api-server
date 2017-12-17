module Authorization
  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session[:user_id] = nil
  end

  def current_user
    User.find(session[:user_id])
  end

  def is_logged_in?
    if current_user
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
