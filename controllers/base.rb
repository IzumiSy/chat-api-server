require_relative "../services/auth_service"

class RouteBase < Sinatra::Base
  include AuthService

  configure do
    set :raise_errors, false
    set :show_exceptions, false

    helpers Sinatra::Param
    helpers Sinatra::Errorcodes

    register Sinatra::CrossOrigin

    enable :cross_origin
    enable :logging
  end

  error do |e|
    handle_errorcode(e)
  end

  error Mongoid::Errors::MongoidError do |e|
    status case e
      when Mongoid::Errors::Validations
        HTTPError::BadRequest::CODE
      else
        HTTPError::InternalServerError::CODE
      end
    body e.summary
  end

  helpers do
    def is_logged_in?
      unless _token = AuthService.is_logged_in?(request)
        raise HTTPError::Unauthorized
      end
      _token
    end

    def is_admin?
      unless _user = AuthService.is_admin?(request)
        raise HTTPError::Unauthorized
      end
      _user
    end
  end
end
