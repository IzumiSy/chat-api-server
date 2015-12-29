Mongoid.load!('mongoid.yml')

class Room
  include Mongoid::Document

  has_many :messages
  has_many :users

  field :name, type: String

  field :messages_count, type: Integer, default: 0
  field :users_count, type: Integer, default: 0

  field :status, type: Integer, default: 0
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true
  validates :name, uniqueness: true
end

