require_relative 'helpers/authorization'
require_relative 'helpers/validation'

class RouteBase < Sinatra::Base
  configure do
    register Sinatra::Errorcodes
    register Sinatra::Namespace

    disable :raise_errors
    disable :show_exceptions
    disable :protection

    enable :halt_with_errors
    enable :logging

    use Rack::PostBodyContentTypeParser
    use Rack::Cors do
      allow do
        origins ENV.fetch('CORS_ALLOWED_ORIGINS', 'http://localhost:8000')
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: true
      end
    end
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
