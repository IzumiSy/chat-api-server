require 'sysrandom/securerandom'

require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/base'
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
require 'rack-health'
require 'rack-cache'
require 'rack/session/dalli'
require 'rack/cors'

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

  use Rack::Health, path: '/healthcheck'
  use Rack::SslEnforcer, except_environments: ['development', 'test']
  use Mongoid::QueryCache::Middleware

  use Rack::Cors do
    allow do
      origins ENV.fetch('CORS_ALLOWED_ORIGINS', 'localhost:8000')
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
    end
  end

  memcached_servers =
    ENV.fetch('MEMCACHEDCLOUD_SERVERS', '127.0.0.1:11211')

  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  set :session_store, Rack::Session::Dalli,
    key: '__chat_api_server',
    cache: Dalli::Client.new(
      memcached_servers,
      username: ENV['MEMCACHEDCLOUD_USERNAME'],
      password: ENV['MEMCACHEDCLOUD_PASSWORD']
    )

  use Rack::Cache,
    verbose: true,
    metastore: "memcached://#{memcached_servers}",
    entitystore: "memcached://#{memcached_servers}"
end
