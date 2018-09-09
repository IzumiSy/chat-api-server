require_relative 'helpers/authorization'
require_relative 'helpers/validation'

class RouteBase < Sinatra::Base
  use Rack::PostBodyContentTypeParser

  configure do
    register Sinatra::Errorcodes
    register Sinatra::Namespace

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
