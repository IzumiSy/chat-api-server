require 'rake'
require_relative './app'

include Rake::DSL

desc 'Run console'
task :console do
  exec 'pry -r ./app.rb'
end

namespace :rooms do
  desc 'Create rooms'
  task :seed do
    Room.create!(name: "Lobby")
    Room.create!(name: "Michelle")
    Room.create!(name: "Blankey")
    Room.create!(name: "Number")
  end

  desc 'Delete all rooms'
  task :drop do
    Room.delete_all
  end
end

namespace :users do
  desc 'Delete all users'
  task :drop do
    User.delete_all
    Room.all.each do |room|
      room.update_attribute(:users_count, 0);
    end
  end
end
