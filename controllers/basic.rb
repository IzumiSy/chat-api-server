
class BasicRoutes < Sinatra::Base
  helpers Sinatra::Param

  get '/api/ping' do
    body 'pong'
  end

  post '/api/user/new' do
    redis = Redis.new

    begin
      redis.ping
    rescue Exception => e
      print "#{e.message}\n"
    end

    param :name, String, required: true
    uuid = SecureRandom.uuid
  end
end

