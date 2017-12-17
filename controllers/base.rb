require_relative 'helpers/authorization'
require_relative 'helpers/validation'

class RouteBase < Sinatra::Base
  configure do
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

  helpers Authorization, Validation
end
