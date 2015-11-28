
class BasicRoutes < Sinatra::Base
  get '/api/ping' do
    body 'pong'
  end
end

