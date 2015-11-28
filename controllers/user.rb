
class UserRoutes < Sinatra::Base
  helpers Sinatra::Param

  post '/api/user/new' do
    param :name, String, required: true
    uuid = SecureRandom.uuid
    name = params[:name]
  end
end
