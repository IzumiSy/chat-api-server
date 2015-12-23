FactoryGirl.define do
  factory :user, class: User do
    name  { "Jonathan Livingston" }
    face  { "face1" }
    ip    { "142.3.23.123" }
    token { "abcdef12345" }
  end

  factory :user2, class: User do
    name  { "Jimmy Jimmy" }
    face  { "face1" }
    ip    { "124.35.46.2" }
    token { "adhfis21234" }
  end

  factory :admin, class: User do
    name     { "Tetsuya Ishino" }
    face     { "face2" }
    ip       { "134.4.13.123" }
    token    { "12345abcd" }
    is_admin { true }
  end
end
