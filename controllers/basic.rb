
class BasicRoutes < Sinatra::Base
  helpers Sinatra::Param

  get '/api/ping' do
    body 'pong'
  end
end

