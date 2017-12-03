require_relative "./base"

class BasicRoutes < RouteBase
  get '/api/ping' do
    body 'pong'
  end

  # Update is_admin flag of the given user to true
  # in order to allow call of admin restricted API
  post '/api/admin/auth' do
    validates do
      required("auth_hash").filled(:str?)
      required("user_id").filled(:str?)
    end

    admin_pass = ENV['ADMIN_PASS']
    if admin_pass.empty?
      raise HTTPError::InternalServerError, "ADMIN_PASS is not set"
    end

    login_hash = params[:auth_hash]
    user_id = params[:user_id]

    password_hash = Digest::MD5.hexdigest(admin_pass)
    unless password_hash == login_hash
      raise HTTPError::Unauthorized
    end

    user = User.find_by!(id: user_id)
    user.update_attribute(:is_admin, true)
    body user.to_json(only: User::USER_DATA_LIMITS.dup << :is_admin)
  end
end

