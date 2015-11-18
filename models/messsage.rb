require 'mongoid'

Mongoid.load!('mongoid.yml')

class Message
  include Mongoid::Document
  include Mongoid::Timestanps

  belongs_to :room, index: true

  field :content, type: String
  field :channel_id, type: String

  validates :content, presence: true
end
