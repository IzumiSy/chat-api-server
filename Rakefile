require_relative './app'

namespace :db do
  task :seed_rooms do
    p Room.create!(name: "Lobby")
    p Room.create!(name: "Michelle")
    p Room.create!(name: "Blankey")
    p Room.create!(name: "Number")
  end

  task :drop_rooms do
    p Room.delete_all
  end

  task :drop_users do
    p User.delete_all
  end
end
