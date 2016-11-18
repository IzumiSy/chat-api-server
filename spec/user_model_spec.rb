require_relative "./spec_helper.rb"

describe User do
  it { is_expected.to belong_to(:room) }
end
