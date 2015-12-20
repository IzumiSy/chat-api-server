require_relative '../services/redis_service'

class BasicRoutes < Sinatra::Base
  include RedisService

  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  before do
    @redis = RedisService.connect(takeover: true)
  end

  get '/api/ping' do
    body 'pong'
  end

  post '/api/admin/auth' do
    param :auth_hash, String, required: true

    admin_pass = ENV['ADMIN_PASS']
    login_hash = params[:auth_hash]

    halt 500 if admin_pass.empty?
    halt 400 if login_hash.empty?

    # Checks if MD5 hash is really the same as the one in .env
    # this port gives back an access token for some restricted API
    password_hash = Digest::MD5.hexdigest(admin_pass)
    if password_hash == login_hash
      now = Time.now.to_s
      auth_token = Digest::MD5.new.update(now).to_s

      client_ip = request.ip.to_s
      @redis.set(client_ip, auth_token)

      response = { auth_token: auth_token }
      body response.to_json
      status 200
    else
     status 401
    end
  end
end

