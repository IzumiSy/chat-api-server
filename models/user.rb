require_relative "../services/redis_service"

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include RedisService

  before_create :generate_user_token

  belongs_to :room
  has_many   :messages

  FACE_TYPES = [
    FACE1 = 1867,
    FACE2 = 1870,
    FACE3 = 1874,
    FACE4 = 1898,
    FACE5 = 1900,
    FACE6 = 1968,
    FACE7 = 1973
  ].freeze

  field :name,   type: String
  field :face,   type: String

  field :ip,     type: String
  field :token,  type: String

  field :messages_count, type: Integer, default: 0

  STATUS = [
    NEUTRAL = 0
  ].freeze

  field :status, type: Integer, default: 0
  field :is_admin, type: Boolean, default: false
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true
  validates :ip, presence: true, uniqueness: true, if: :is_global_ip?

  public

  def self.fetch_user_data(user_id, type)
    user = User.only(:id, :name, :face, :room).find(user_id)
    unless user
      return 404, "User not found"
    end

    return case type
      when :USER then
        user = Hash[user.attributes].slice("_id", "name", "face")
        [ 200, user.to_json ]
      when :ROOM then
        room = Hash[user.room.attributes].slice("_id", "name", "messages_count", "users_count")
        [ 200, room.to_json ]
      else
        [ 500, {}.to_json ]
      end
  end

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
    puts "[INFO] Token set: #{token}"
  end
end
