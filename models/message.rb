Mongoid.load!('mongoid.yml')

require_relative "../services/message_service"

class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  after_save :broadcast_message

  belongs_to :room, counter_cache: :messages_count
  belongs_to :user, counter_cache: :users_count

  field :content, type: String
  field :status,  type: Integer

  validates :content, presence: true

  protected

  def broadcast_message
    # Broadcast the message with steaming API in Sinatra
  end
end
