require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/base'
require 'sinatra/rocketio'
require 'sinatra/errorcodes'
require 'sinatra/async'

require 'sysrandom/securerandom'
require 'digest/md5'

require 'mongoid'
require 'mongoid/paranoia'
require 'dry-validation'

require 'parallel'
require 'promise'

require 'dotenv'
require 'pry' if development? or test?

require 'rack-ssl-enforcer'
require 'rack-health'
require 'rack-cache'
require 'rack/session/dalli'
require 'rack/cors'
require 'rack/contrib'

require_relative 'controllers/basic'
require_relative 'controllers/room'
require_relative 'controllers/message'
require_relative 'controllers/user'

require_relative 'models/room'
require_relative 'models/user'

Dotenv.load
Mongoid.load!('mongoid.yml', ENV['RACK_ENV'])

class Application < Sinatra::Base
  configure do
    register Sinatra::RocketIO
    register Sinatra::Async

    set :rocketio, websocket: false, comet: true

    use Rack::Health, path: '/healthcheck'
    use Rack::SslEnforcer, except_environments: ['development', 'test']
    use Mongoid::QueryCache::Middleware

    use BasicRoutes
    use UserRoutes
    use RoomRoutes
    use MessageRoutes
  end
end
