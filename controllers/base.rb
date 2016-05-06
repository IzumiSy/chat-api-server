
class RouteBase < Sinatra::Base
  configure do
    set :raise_errors, true
    set :show_exceptions, false

    helpers Sinatra::Param

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  error do |exception|
    # TODO need exception handling
    status 500
  end
end
