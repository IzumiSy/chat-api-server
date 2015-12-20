require 'digest/md5'
require 'dotenv'

Dotenv.load!

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

    admin_pass = ENV['ADMIN_PASS']
    login_hash = params[:md5_hash]

    if admin_pass.empty? or login_hash.empty?
      halt 500
    end

    # Checks if MD5 hash is really the same as the one in .env
    # this port gives back an access token for some restricted API
    password_hash = Digest::MD5.hexdigest(admin_pass)
    if password_hash == login_hash
      now = Time.now.to_s
      auth_token = Digest::MD5.new.update(now)

      response = {
        auth_token: auth_token.to_s
      }
      body response.to_json
      status 200
    else
     status 401
    end
  end
end

