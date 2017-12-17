require_relative "../services/redis_service"

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  USER_NAME_LENGTH_MAX = 64
  USER_DATA_LIMITS = [:_id, :name, :face]

  belongs_to :room, foreign_key: 'room_id', optional: true

  FACE_ID_BASE = 144995
  FACE_IDS = [
    1867, 1870, 1874, 1898, 1900, 1968, 1973
  ].freeze

  field :name,   type: String
  field :face,   type: String, default: ->{ faceid_gen() }

  field :ip,      type: String
  field :session, type: String

  STATUS = [
    STATUS_NEUTRAL = 0
  ].freeze

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
      !!User.where(name: name).exists?
    end

    def find_user_by_session(session)
      Mongoid::QueryCache.cache { User.find_by(session: session) }
    end

    def find_user_by_ip(ip)
      Mongoid::QueryCache.cache { User.find_by(ip: ip) }
    end

    def fetch_user_data(user_id, fetch_type)
      return case fetch_type
        when :USER then
          User.only(:id, :name, :face).find_by!(id: user_id).to_json(only: USER_DATA_LIMITS)
        when :ROOM then
          User.only(:room).find_by!(id: user_id).room.to_json(only: Room::ROOM_DATA_LIMITS)
        else
          raise HTTPError::InternalServerError
        end
    end

    def trigger_disconnection_resolver(client)
      Thread.new {
        if user = User.find_user_by_session(client.session)
          User.user_deletion(user)
        end
      }
    end

    def user_deletion(user)
      return unless user
      if user.room
        Room.room_transaction(user.room.id, user, :LEAVE)
      end
      user.delete
    end
  end

  private

  # Set random face id
  def faceid_gen
    faceid = FACE_IDS[rand(FACE_IDS.length)]
    "#{FACE_ID_BASE}#{faceid}"
  end
end
