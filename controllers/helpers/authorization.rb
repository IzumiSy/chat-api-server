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

  def must_be_logged_in!
    raise HTTPError::Unauthorized unless current_user
  end

  def must_be_logged_in_as_admin!
    raise HTTPError::Unauthorized unless current_user && current_user.is_admin?
  end
end
