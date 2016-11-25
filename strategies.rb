require 'warden'

Warden::Strategies.add(:TokenAuthorization) do
  def valid?
    auth = Rack::Auth::Basic::Request.new(request.env)
    if auth.provided? and auth.basic?
      token = auth.params
    else
      return false
    end

    # TODO
  end

  def authenticate!
    # TODO
  end
end
