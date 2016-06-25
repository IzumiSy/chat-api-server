require_relative "../services/auth_service"

class RouteBase < Sinatra::Base
  include AuthService

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

  helpers do
    def is_logged_in?
      if _token = AuthService.is_logged_in?(request)
        _token
      else
        halt 401
      end
    end

    def is_admin?
      if _user = AuthService.is_admin?(request)
        _user
      else
        halt 401
      end
    end
  end
end
