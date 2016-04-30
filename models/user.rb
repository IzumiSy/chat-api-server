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

  field :ip,      type: String
  field :token,   type: String
  field :session, type: String

  field :messages_count, type: Integer, default: 0

  index({ name: 1 }, { unique: true, name: 'name_index', background: true })
  index({ ip:   1 }, { unique: true, name: 'ip_index',   background: true })

  STATUS = [
    STATUS_NEUTRAL = 0
  ].freeze

  DISCONNECTION_RESOLVE_INTERVAL = 3

  field :status, type: Integer, default: self::STATUS_NEUTRAL
  field :is_admin, type: Boolean, default: false
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true, uniqueness: true

  public

  class << self
    def fetch_user_data(user_id, type)
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

    def resolve_disconnected_users(user_id, new_session)
      EM.defer do
        user = User.find(user_id)
        return unless user
        if user.session == new_session
          User.user_deletion(user)
        end
      end
    end

    def user_deletion(user)
      if user
        if user.room
          Room.room_transaction(user.room.id, user.token, :LEAVE)
        end
        RedisService.connect(takeover: true)
        RedisService.delete(user.token)
        user.delete
      end
    end

    def trigger_disconnection_resolver(client)
      EM.defer do
        if user = User.find_by(session: client.session)
          EM.add_timer(self::DISCONNECTION_RESOLVE_INTERVAL) do
            User.resolve_disconnected_users(user.id, client.session)
          end
        end
      end
    end
  end

  protected

  # Generate user token randomly
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
