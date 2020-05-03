require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/base'
require 'sinatra/rocketio'
require 'sinatra/errorcodes'
require 'sinatra/async'

require 'sysrandom/securerandom'
require 'digest/md5'

require 'mongoid'

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
    use BasicRoutes
    use UserRoutes
    use RoomRoutes
    use MessageRoutes
  end
end
