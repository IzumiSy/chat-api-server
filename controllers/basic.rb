
class BasicRoutes < Sinatra::Base
  helpers Sinatra::Param

  get '/api/ping' do
    body 'pong'
  end

  post '/api/user/new' do
    begin
      redis = Redis.new(driver: :hiredis)
      redis.ping
    rescue Exception => e
      print("#{e.message}\n")
    end
    param :name, String, required: true
    uuid = SecureRandom.uuid
    name = params[:name]
    redis.set(uuid, name)
    print("{ uuid: #{uuid}, name: #{name} }\n")
  end
end

