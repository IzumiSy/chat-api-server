require_relative "../services/redis_service"

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include RedisService

  USER_NAME_LENGTH_MAX = 64
  USER_DATA_LIMITS = [:_id, :name, :face]

  before_create :generate_user_token

  belongs_to :room, foreign_key: 'room_id'

  FACE_ID_BASE = 144995
  FACE_IDS = [
    1867, 1870, 1874, 1898, 1900, 1968, 1973
  ].freeze

  field :name,   type: String
  field :face,   type: String, default: ->{ faceid_gen() }

  field :ip,      type: String
  field :token,   type: String
  field :session, type: String

  index({ name: 1 }, { unique: true, name: 'name_index', background: true })
  index({ ip:   1 }, { unique: true, name: 'ip_index',   background: true })

  STATUS = [
    STATUS_NEUTRAL = 0
  ].freeze

  DISCONNECTION_RESOLVE_INTERVAL = 3

  field :status, type: Integer, default: self::STATUS_NEUTRAL
  field :is_admin, type: Boolean, default: false

  validates :name, presence: true, uniqueness: true,
    absence: false, length: {
      minimum: 0,
      maximum: self::USER_NAME_LENGTH_MAX
    }
  validates :face, absence: false
  validates_inclusion_of :face, in: ->(_) do
    FACE_IDS.map { |f| "#{FACE_ID_BASE}#{f}" }
  end

  public

  class << self
    def get_name_availability(name)
      !User.where(name: name).exists?
    end

    def fetch_user_data(user_id, fetch_type)
      user = User.only(:id, :name, :face, :room).find_by!(id: user_id)

      return case fetch_type
        when :USER then
          user.to_json(only: USER_DATA_LIMITS)
        when :ROOM then
          user.room.to_json(only: Room::ROOM_DATA_LIMITS)
        else
          raise HTTPError::InternalServerError
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
  def faceid_gen
    faceid = FACE_IDS[rand(FACE_IDS.length)]
    "#{FACE_ID_BASE}#{faceid}"
  end
end
