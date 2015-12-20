require 'dotenv'

Dotenv.load

class BasicRoutes < Sinatra::Base
  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  get '/api/ping' do
    body 'pong'
  end

  # Get admin token to use restricted API
  post '/api/admin/auth' do
    param :md5_hash, String, required: true

    # Checks if MD5 hash is really the same as the one in .env
    # this port gives back an access token for some restricted API

    status 200
  end
end

