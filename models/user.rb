require 'mongoid'
require 'bcrypt'

Mongoid.load!('mongoid.yml')

class User
  include Mongoid::Document

  field :name
  field :email

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, presence: true
  validates :name, uniqueness: true
end

