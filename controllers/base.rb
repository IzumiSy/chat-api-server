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

    memcached_servers =
      ENV.fetch('MEMCACHEDCLOUD_SERVERS', '127.0.0.1:11211')

    use Rack::Session::Dalli,
      key: 'rack.session',
      cache: Dalli::Client.new(
        memcached_servers,
        username: ENV['MEMCACHEDCLOUD_USERNAME'],
        password: ENV['MEMCACHEDCLOUD_PASSWORD']
      )

    use Rack::Cache,
      verbose: true,
      metastore: "memcached://#{memcached_servers}",
      entitystore: "memcached://#{memcached_servers}"

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
