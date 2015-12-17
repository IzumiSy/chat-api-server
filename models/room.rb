
Mongoid.load!('mongoid.yml')

class Room
  include Mongoid::Document

  after_save :handle_room_enter
  after_destroy :handle_room_leave

  has_many :messages
  has_many :users

  field :name, type: String
  field :messages_count, type: Integer

  field :status, type: Integer, default: 0
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true
  validates :name, uniqueness: true

  protected

  def handle_room_enter
    # Handles user entering to the room
  end

  def handle_room_leave
    # Handles user leaving from the room
  end
end

