require_relative "./spec_helper.rb"

describe Room do
  it { is_expected.to be_timestamped_document }
  it { is_expected.to be_paranoid_document }

  it { is_expected.to have_many(:users).with_foreign_key(:room_id) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to have_field(:status).of_type(Integer) }
  it { is_expected.to have_field(:is_deleted).of_type(Mongoid::Boolean) }
end