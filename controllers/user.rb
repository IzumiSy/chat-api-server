
class UserRoutes < Sinatra::Base
  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

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

  get '/api/user/usable/:name' do
    param :name, String, required: true

    provided_name = params[:name]
    is_name_availability = User.where(name: provided_name).exists?

    result = {
      status: !is_name_availability
    }
    body result.to_json
    status 200
  end
end
