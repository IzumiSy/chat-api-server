require_relative "../spec_helper.rb"

describe "POST /api/room/new" do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:success_room) { { name: "RoomSuccess" } }
  let(:error_room) { { name: "RoomError" } }
  let(:duplicated_room) { { name: "SuperRoom" } }
  let!(:SuperRoom) { create(:SuperRoom) }

  it "should NOT create a room without parameters" do
    post "/api/room/new", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(401)
  end

  it "should NOT create a room by non-admin user" do
    post "/api/room/new", error_room, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(401)
  end

  it "should NOT create a room because of name duplication" do
    post "/api/room/new", duplicated_room, 'rack.session' => { user_id: admin.id }
    expect(last_response.status).to eq(400)
  end

  it "should craete a room successfully" do
    post "/api/room/new", success_room, 'rack.session' => { user_id: admin.id }
    expect(last_response.status).to eq(200)
  end
end

# TODO Need implementation
describe "GET /api/room" do
  it "should get messages of the room" do

  end
end

describe "GET /api/room/:id/users" do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:room) { create(:room) }

  before do
    enter_room(room.id, user)
    enter_room(room.id, admin)
  end

  it "should have 2 users in the room" do
    get "/api/room/#{room.id}/users", {}, 'rack.session' => { user_id: user.id }
    users = JSON.parse(last_response.body).collect { |user| user["_id"]["$oid"] }
    expect(last_response.status).to eq(200)
    expect(users).to include(user.id.to_s, admin.id.to_s)
  end
end

describe "POST /api/room/enter" do
  let(:room) { create(:room) }
  let(:user) { create(:user) }

  it "should get an 404 error with invalid room id" do
    post "/api/room/12345/enter", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(404)
  end

  # TODO Implement room check if the user successfully entered
  it "should have an user enter the room" do
    post "/api/room/#{room.id}/enter", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(200)
    expect(room.users.count).to eq(1)
    expect(room.users.first.id).to eq(user.id)
  end

  it "should get 500 error with invalid type" do
    post "/api/room/#{room.id}/nothing", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(404)
  end
end

describe "POST /api/room/:id/leave" do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  # TODO Implement room check if the user successfully leaved
  it "should have an user leave the room" do
    enter_room(room.id, user)
    enter_room(room.id, admin)
    post "/api/room/#{room.id}/leave", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(200)
    expect(room.users.first).to eq(admin)
    expect(room.users.count).to eq(1)
  end

  # TODO Implement room check if the user successfully leaved
  it "should have an user leave the room with 'all' for :id" do
    enter_room(room.id, user)
    enter_room(room.id, admin)
    post "/api/room/all/leave", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(200)
    expect(room.users.first).to eq(admin)
    expect(room.users.count).to eq(1)
  end
end

