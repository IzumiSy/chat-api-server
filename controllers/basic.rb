redis = Redis.new

class BasicRoutes < Sinatra::Base
  get '/api/ping' do
    body 'pong'
  end

  post '/api/user/new' do
    param :name, String, required: true
  end
end

