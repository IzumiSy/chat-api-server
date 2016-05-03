FactoryGirl.define do
  factory :Lobby, class: Room do
    name { "Lobby" }
  end

  factory :room, class: Room do
    name { "TestRoom" }
  end

  factory :SuperRoom, class: Room do
    name { "SuperRoom" }
  end
end

