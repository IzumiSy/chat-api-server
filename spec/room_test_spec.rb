require_relative "./spec_helper.rb"

describe "POST /api/room/new" do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:success_room) { { name: "RoomSuccess", token: admin.token } }
  let(:error_room) { { name: "RoomError", token: user.token } }

  it "should NOT create a room without parameters" do
    post "/api/room/new"
    expect(last_response.status).to eq(400)
  end

  it "should NOT create a room by non-admin user" do
    post "/api/room/new", error_room
    expect(last_response.status).to eq(401)
  end

  it "should have 2 posts that correctly belong to the room" do
    post "/api/room/new", success_room
    expect(last_response.status).to eq(202)
  end
end

# TODO Need implementation
describe "GET /api/room" do
  it "should get messages of the room" do

  end
end

describe "GET /api/room/:id/messages" do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:msgs) { [
    { content: "Hello1", token: user.token },
    { content: "Hello2", token: user.token }
  ] }

  it "should have 2 messages" do
    # TODO: rewrite here with FactoryGirl
    msgs.each do |msg|
      post "/api/message/#{room.id}", msg
      expect(last_response.status).to eq(202)
    end

    messages_count = Message.where(room_id: room.id).count
    expect(messages_count).to eq(2)

    room_messages_count = Room.find(room.id).messages.count
    expect(room_messages_count).to eq(messages_count)
  end
end

describe "GET /api/room/:id/users" do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:room) { create(:room) }

  before do
    enter_room(room.id, user.token)
    enter_room(room.id, admin.token)
  end

  it "should have 2 users in the room" do
    get "/api/room/#{room.id}/users", { token: user.token }
    users = JSON.parse(last_response.body)
    expect(users).to include(
      Hash[user.attributes].slice("_id", "name", "face"),
      Hash[admin.attributes].slice("_id", "name", "face")
    )
  end
end

describe "POST /api/room/enter" do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:param) { { room_id: room.id, token: user.token } }
  let(:invalid_param) { { room_id: "12345", token: user.token } }

  it "should get an 404 error with invalid room id" do
    post "/api/room/enter", invalid_param
    expect(last_response.status).to eq(404)
  end

  # TODO Implement room check if the user successfully entered
  it "should have an user enter the room" do
    post "/api/room/enter", param
    expect(last_response.status).to eq(202)
    expect(room.users.count).to eq(1)
    expect(room.users.first.id).to eq(user.id)
  end
end

describe "POST /api/room/leave" do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:param) { { room_id: room.id, token: user.token } }
  let(:invalid_param) { { room_id: "12345", token: user.token } }

  it "should get an 404 error with invalid room id" do
    post "/api/room/leave", invalid_param
    expect(last_response.status).to eq(404)
  end

  # TODO Implement room check if the user successfully leaved
  it "should have an user leave the room" do
    enter_room(room.id, user.token)

    post "/api/room/leave", param
    expect(last_response.status).to eq(202)
    expect(room.users.count).to eq(0)
  end
end

