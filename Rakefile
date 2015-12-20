require_relative './app'

namespace :db do
  task :seed_rooms do
    Room.create!(name: "Lobby")
    Room.create!(name: "Michelle")
    Room.create!(name: "Blankey")
    Room.create!(name: "Number")
  end

  task :drop_rooms do
   Room.delete_all
  end
end
