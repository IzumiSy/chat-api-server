
Mongoid.load!('mongoid.yml')

class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :room, counter_cache: :messages_count
  belongs_to :user, counter_cache: :message_count

  field :content, type: String
  field :status,  type: Integer

  validates :content, presence: true

  after_save do |messsage|
    # Broadcasts message posting with WebSocket
  end
end
