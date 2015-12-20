Mongoid.load!('mongoid.yml')

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :room, counter_cache: :users_count
  has_many   :messages

  field :name,   type: String
  field :face,   type: String

  field :ip,     type: String
  field :token,  type: String

  field :messages_count, type: Integer

  field :status, type: Integer, default: 0
  field :is_admin, type: Boolean, default: false
  field :is_deleted, type: Boolean, default: false

  validates :name, presence: true
  validates :ip, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true
end
