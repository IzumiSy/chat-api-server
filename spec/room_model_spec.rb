require_relative "./spec_helper.rb"

describe Room do
  it { is_expected.to have_many(:users).with_foreign_key(:room_id) }
end
