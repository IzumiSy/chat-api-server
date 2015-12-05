class BasicRoutes < Sinatra::Base
  configure do
    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  get '/api/ping' do
    body 'pong'
  end
end

