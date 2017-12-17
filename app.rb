require 'sinatra'
require 'sinatra/base'
require 'sinatra/cross_origin'
require 'sinatra/rocketio'
require 'sinatra/errorcodes'
require 'sinatra/async'

require 'dry-validation'
require 'digest/md5'
require 'securerandom'

require 'redis'
require 'mongoid'
require 'mongoid/paranoia'

require 'parallel'
require 'promise'

require 'dotenv'
require 'pry' if development? or test?

require 'rack-ssl-enforcer'

require_relative 'controllers/basic'
require_relative 'controllers/room'
require_relative 'controllers/message'
require_relative 'controllers/user'

require_relative 'models/room'
require_relative 'models/user'

Dotenv.load
Mongoid.load!('mongoid.yml', ENV['RACK_ENV'])

class Application < Sinatra::Base
  register Sinatra::RocketIO
  register Sinatra::Async

  configure do
    set :rocketio, websocket: false, comet: true
  end

  use BasicRoutes
  use UserRoutes
  use RoomRoutes
  use MessageRoutes

  use Rack::SslEnforcer, except_environments: ['development', 'test']
  use Mongoid::QueryCache::Middleware

  options "*" do
    response.headers["Access-Control-Allow-Headers"] =
      "Authorization"
    200
  end

  if (memcached_servers = ENV['MEMCACHE_SERVERS'])
      (memcached_port = ENV['MEMCACHE_PORT']) &&
      (memcached_username = ENV['MEMCACHE_USERNAME']) &&
      (memcached_password = ENV['MEMCACHE_PASSWORD'])

    use Rack::Cache,
      verbose: true,
      metastore: "memcached://#{memcached_servers}",
      entitystore: "memcached://#{memcached_servers}"

    use Rack::Session::Dalli,
      cache: Dalli::Client.new(
        "#{memcached_servers}:#{memcached_port}",
        username: memcached_username,
        password: memcached_password
      )
  end
end
