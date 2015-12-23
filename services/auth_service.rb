require_relative "./redis_service.rb"

module AuthService
  def self.is_admin?(params)
    # TODO: Check id is_admin flag of this user is true or not
  end

  def self.is_logged_in?(params)
    # TODO: Check if this user is being logged in or not
  end
end
