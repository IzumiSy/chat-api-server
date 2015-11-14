require 'mongoid'
require 'bcrypt'

Mongoid.load!('mongoid.yml')

class User
  include Mongoid::Document

  field :name

  validates :name, presence: true
  validates :name, uniqueness: true
end

