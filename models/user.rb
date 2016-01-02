require_relative "../services/redis_service"

Mongoid.load!('mongoid.yml')

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include RedisService

  before_create :generate_user_token

  belongs_to :room
  has_many   :messages

  field :name,   type: String
  field :face,   type: String

  field :ip,     type: String
  field :token,  type: String

  field :messages_count, type: Integer, default: 0

  field :status, type: Integer, default: 0
  field :is_admin, type: Boolean, default: false
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true
  validates :ip, presence: true, uniqueness: true, if: :is_global_ip?

  protected

  # Disable validation on development env
  def is_global_ip?
    env = ENV["RACK_ENV"]
    return (if env == "production" then true else ip != "127.0.0.1" end)
  end

  def generate_user_token
    token = SecureRandom.uuid
    RedisService.connect(takeover: true)
    RedisService.set(token, self.ip)
    self.token = token
    logger.info "[INFO] Token set: #{token}"
  end
end
