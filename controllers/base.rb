require_relative "../services/auth_service"

class RouteBase < Sinatra::Base
  configure do
    helpers Sinatra::Param

    register Sinatra::CrossOrigin
    register Sinatra::Errorcodes

    set :raise_errors, false
    set :show_exceptions, false
    set :halt_with_errors, true

    enable :cross_origin
    enable :logging
  end

  before do
    content_type :json
  end

  error do |e|
    status case e
      when Mongoid::Errors::Validations
        HTTPError::BadRequest::CODE
      when Mongoid::Errors::DocumentNotFound
        HTTPError::NotFound::CODE
      when Mongoid::Errors::MongoidError
        HTTPError::InternalServerError::CODE
      end
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
