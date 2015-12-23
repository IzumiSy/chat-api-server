FactoryGirl.define do
  sequence :name do Faker::Name.name end
  sequence :ip   do Faker::Internet.ip_v4_address end
end

FactoryGirl.define do
  factory :user, class: User do
    name  { generate :name }
    face  { "face1" }
    ip    { generate :ip }
    token { "abcdef12345" }
  end

  factory :user2, class: User do
    name  { generate :name }
    face  { "face1" }
    ip    { generate :ip }
    token { "adhfis21234" }
  end

  factory :admin, class: User do
    name     { generate :name }
    face     { "face2" }
    ip       { generate :ip }
    token    { "12345abcd" }
    is_admin { true }
  end
end
