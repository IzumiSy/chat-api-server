require_relative "./spec_helper.rb"

describe User do
  it { is_expected.to belong_to(:room) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  it { is_expected.to have_fields(:name, :face).of_type(String) }
  it { is_expected.to have_fields(:ip, :token, :session).of_type(String) }
  it { is_expected.to have_fields(:is_admin, :is_deleted).of_type(Mongoid::Boolean) }
  it { is_expected.to have_field(:status).of_type(Integer) }
end
