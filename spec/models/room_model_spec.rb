require_relative "../spec_helper.rb"

describe Room do
  it { is_expected.to have_many(:users).with_foreign_key(:room_id) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_length_of(:name).within(0..Room::ROOM_TITLE_LENGTH_MAX) }

  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to have_field(:status).of_type(Integer) }
  it { is_expected.to have_timestamps }
end
