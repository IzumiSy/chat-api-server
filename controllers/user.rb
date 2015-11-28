
class UserRoutes < Sinatra::Base
  helpers Sinatra::Param

  post '/api/user/new' do
    param :name, String, required: true
    client_ip = request.ip
    client_uuid = SecureRandom.uuid
    client_name = params[:name]
  end
end
