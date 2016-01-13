require_relative "../services/message_service"

class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include MessageService

  MESSAGE_DATA_LIMITS = [:_id, :created_at, :user_id, :content].freeze

  after_save :broadcast_message

  belongs_to :room
  belongs_to :user

  field :content, type: String
  field :status,  type: Integer, default: 0

  validates :content, presence: true

  protected

  def broadcast_message
    MessageService.broadcastMessage(self)
  end
end
