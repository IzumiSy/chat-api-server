module Authorization
  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session[:user_id] = nil
  end

  def current_user
    session[:user_id] && User.find(session[:user_id])
  end

  def is_logged_in?
    if current_user
      true
    else
      false
    end
  end

  def is_admin?
    if current_user && current_user.is_admin?
      true
    else
      false
    end
  end
end
