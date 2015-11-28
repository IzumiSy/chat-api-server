
Mongoid.load!('mongoid.yml')

class Room
  include Mongoid::Document

  has_many :messages
  has_many :users

  field :name, type: String
  field :messages_count, type: Integer
  field :status, type: Integer

  validates :name, presence: true
  validates :name, uniqueness: true
end

