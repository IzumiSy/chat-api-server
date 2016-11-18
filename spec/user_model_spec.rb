require_relative "./spec_helper.rb"

describe User do
  it { is_expected.to belong_to(:room) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
