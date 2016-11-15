require_relative "./base"

class BasicRoutes < RouteBase
  get '/api/ping' do
    body 'pong'
  end

  # Update is_admin flag of the given user to true
  # in order to allow call of admin restricted API
  post '/api/admin/auth' do
    param :auth_hash, String, required: true
    param :user_id, String, required: true

    admin_pass = ENV['ADMIN_PASS']
    if admin_pass.empty?
      raise HTTPError::InternalServerError, "ADMIN_PASS is not set"
    end

    login_hash = params[:auth_hash]
    user_id = params[:user_id]

    password_hash = Digest::MD5.hexdigest(admin_pass)
    if password_hash == login_hash
      body user_admin_promotion(user_id)
    else
      raise HTTPError::Unauthorized
    end
  end

  protected

  def user_admin_promotion(user_id)
    unless user = User.find(user_id)
      raise HTTPError::InternalServerError, "User Not Found"
    end

    user.update_attribute(:is_admin, true)
    return user.to_json(only: User::USER_DATA_LIMITS.dup << :is_admin)
  end
end

