
class UserRoutes < Sinatra::Base
  helpers Sinatra::Param

  post '/api/user/new' do
    param :name, String, required: true

    client_ip = request.ip
    client_uuid = SecureRandom.uuid
    client_name = params[:name]

    return if client_ip.empty? or client_name.empty?

    user = User.create(name: client_name, ip: client_ip, token: client_uuid)
    p user
    body user.to_json
    status 202
  end

  get '/api/user/usable' do
    param :name, String, required: true

    # Check if the provided name is available or not

    status 200
  end
end
