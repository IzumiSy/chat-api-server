require 'sinatra'
require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/cross_origin'
require 'sinatra/rocketio'
require 'sinatra/errorcodes'

require 'digest/md5'
require 'securerandom'

require 'mongoid'
require 'mongoid/paranoia'

require 'redis-sinatra'

require 'parallel'
require 'promise'

require 'rack-ssl-enforcer'

require 'warden'

require 'dotenv'
require 'pry' if development? or test?

require_relative 'controllers/basic'
require_relative 'controllers/room'
require_relative 'controllers/message'
require_relative 'controllers/user'

require_relative 'models/room'
require_relative 'models/user'

Dotenv.load
Mongoid.load!('mongoid.yml', ENV['RACK_ENV'])

class Application < Sinatra::Base
  register Sinatra::Cache
  register Sinatra::RocketIO

  configure do
    set :cometio, timeout: 360, post_interval: 1
    set :rocketio, websocket: false, comet: true
  end

  not_found do
    raise HTTPError::NotFound
  end

  use BasicRoutes
  use UserRoutes
  use RoomRoutes
  use MessageRoutes

  use Rack::SslEnforcer, except_environments: ['development', 'test']
  use Mongoid::QueryCache::Middleware

  use Warden::Manager do |config|
    config.failure_app = self
    config.default_scope = :user
    config.scope_defaults :user, strategies: [:user]
    config.scope_defaults :admin, strategies: [:admin]
  end

  options "*" do
    response.headers["Access-Control-Allow-Headers"] =
      "Authorization"
    200
  end
end
