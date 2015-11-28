
Mongoid.load!('mongoid.yml')

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :room
  has_many   :message, index: true

  field :name, type: String

  validates :name, presence: true
end
