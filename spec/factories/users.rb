FactoryGirl.define do
  factory :user1, class: User do
    name "Jonathan Livingston"
    face "face1"
    ip "127.0.0.1"
    token "abcdef12345"
  end
end
