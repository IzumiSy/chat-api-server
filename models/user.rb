
Mongoid.load!('mongoid.yml')

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  after_save :handle_room_enter
  after_destroy :handle_room_leave

  belongs_to :room, counter_cache: :users_count
  has_many   :messages

  field :name,   type: String
  field :face,   type: String

  field :ip,     type: String
  field :token,  type: String

  field :messages_count, type: Integer

  field :status, type: Integer, default: 0
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true
  validates :ip, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true

  protected

  def handle_room_enter
    # Handles user entering to the room
  end

  def handle_room_leave
    # Handles user leaving from the room
  end
end
