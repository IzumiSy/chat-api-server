require 'mongoid'

Mongoid.load!('mongoid.yml')

class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :room, index: true

  field :content, type: String
  validates :content, presence: true

  after_save do |messsage|
    # Broadcasts message posting with WebSocket
  end
end
