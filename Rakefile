require_relative './app'

task :console do
  exec 'pry -r ./app.rb'
end

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

  task :drop_users do
    User.delete_all
    Room.all.each do |room|
      room.update_attribute(:users_count, 0);
    end
    exec 'redis-cli flushdb'
  end

  task :drop_all do
    Mongoid.purge!
    exec 'redis-cli flushdb'
  end
end
