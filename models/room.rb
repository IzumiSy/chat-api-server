require 'mongoid'

Mongoid.load!('mongoid.yml')

class Room
  include Mongoid::Document

  has_many :messages

  field :name,  type: String

  validates :name, presence: true
  validates :name, uniqueness: true
end

