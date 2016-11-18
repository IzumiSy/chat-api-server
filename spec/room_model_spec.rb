require_relative "./spec_helper.rb"

describe Room do
  it { is_expected.to have_many(:users).with_foreign_key(:room_id) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
