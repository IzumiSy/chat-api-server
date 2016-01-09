Mongoid.load!('mongoid.yml')

require_relative "../services/message_service"

class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include MessageService

  after_save :broadcast_message

  belongs_to :room
  belongs_to :user

  field :content, type: String
  field :status,  type: Integer, default: 0

  validates :content, presence: true

  protected

  def broadcast_message
    MessageService.broadcastMessage(self.room_id.to_s, self.user_id.to_s, self.content)
  end
end
