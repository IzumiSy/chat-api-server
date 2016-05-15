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
    halt 500 if admin_pass.empty?

    login_hash = params[:auth_hash]
    user_id = params[:user_id]

    password_hash = Digest::MD5.hexdigest(admin_pass)
    if password_hash == login_hash
      status_code, result = user_admin_promotion(user_id)
      body result
      status status_code
    else
      body "Invalid authorization"
      status 401
    end
  end

  protected

  def user_admin_promotion(user_id)
    unless user = User.find(user_id)
      return 500, "User not found"
    end

    user.update_attribute(:is_admin, true)
    return 202, user.to_json(only: User::USER_DATA_LIMITS.dup << :is_admin)
  end
end

