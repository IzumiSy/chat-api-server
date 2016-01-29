require_relative "../services/redis_service"

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include RedisService

  USER_DATA_LIMITS = [:_id, :name, :face]

  before_create :generate_user_token, :set_face_id

  belongs_to :room

  FACE_ID_BASE = 144995
  FACE_IDS = [
    1867, 1870, 1874, 1898, 1900, 1968, 1973
  ].freeze

  field :name,   type: String
  field :face,   type: String

  field :ip,     type: String
  field :token,  type: String

  field :messages_count, type: Integer, default: 0

  STATUS = [
    STATUS_NEUTRAL = 0
  ].freeze

  field :status, type: Integer, default: self::STATUS_NEUTRAL
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
        [ 200, user.to_json(only: USER_DATA_LIMITS) ]
      when :ROOM then
        [ 200, user.room.to_json(only: Room::ROOM_DATA_LIMITS) ]
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

  # Set random face id
  def set_face_id
    self.face = (FACE_ID_BASE.to_s + FACE_IDS[rand(FACE_IDS.length)].to_s)
  end
end
