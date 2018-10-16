require 'rake'
require_relative './app'

include Rake::DSL

desc 'Run console'
task :console do
  exec 'pry -r ./app.rb'
end

desc 'Create rooms'
task :seed_rooms do
  Room.create!(name: "Lobby")
  Room.create!(name: "Michelle")
  Room.create!(name: "Blankey")
  Room.create!(name: "Number")
end

desc 'Delete all rooms'
task :drop_rooms do
  Room.delete_all
end

desc 'Delete all users'
task :drop_users do
  User.delete_all
  Room.all.each do |room|
    room.update_attribute(:users_count, 0);
  end
end
