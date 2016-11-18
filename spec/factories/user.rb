FactoryGirl.define do
  sequence :name do Faker::Name.name end
  sequence :ip   do Faker::Internet.ip_v4_address end
end

FactoryGirl.define do
  factory :user, class: User do
    name  { generate :name }
    ip    { generate :ip }
    face  { "1867" }
  end

  factory :user2, class: User do
    name  { generate :name }
    ip    { generate :ip }
    face  { "1870" }
  end

  factory :Jonathan, class: User do
    name  { "Jonathan" }
    ip    { generate :ip }
    face  { "1874" }
  end

  factory :admin, class: User do
    name     { generate :name }
    ip       { generate :ip }
    face     { "1898" }
    is_admin { true }
  end
end
