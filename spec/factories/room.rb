FactoryGirl.define do
  factory :room, class: Room do
    name { "TestRoom" }
  end

  factory :SuperRoom, class: Room do
    name { "SuperRoom" }
  end
end

