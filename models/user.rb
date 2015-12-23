require_relative "../services/redis_service"

Mongoid.load!('mongoid.yml')

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include RedisService

  before_validation :generate_user_token

  belongs_to :room, counter_cache: :users_count
  has_many   :messages

  field :name,   type: String
  field :face,   type: String

  field :ip,     type: String
  field :token,  type: String

  field :messages_count, type: Integer

  field :status, type: Integer, default: 0
  field :is_admin, type: Boolean, default: false
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true
  validates :ip, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true

  protected

  def generate_user_token
    token = SecureRandom.uuid
    RedisService.connect(takeover: true)
    RedisService.set(self.ip, token)
    self.token = token
  end
end
