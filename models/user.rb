
Mongoid.load!('mongoid.yml')

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :room
  has_many   :messages

  field :name,  type: String
  field :ip,    type: String
  field :token, type: String

  validates :name, presence: true
  validates :ip, presence: true, uniquness: true
  validates :token, presence: true, uniqueness: true
end
