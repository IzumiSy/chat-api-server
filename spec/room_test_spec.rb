require_relative "./spec_helper.rb"

describe "POST /api/room/new" do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  let(:success_room) {
    { name: "RoomSuccess",
      token: admin.token }
  }
  let(:error_room) {
    { name: "RoomError",
      token: user.token }
  }

  it "should NOT create a room without parameters" do
    post "/api/room/new"
    expect(last_response.status).to eq(400)
  end

  it "should NOT create a room by non-admin user" do
    post "/api/room/new", error_room
    expect(last_response.status).to eq(401)
  end

  it "should create a new room with a name" do
    post "/api/room/new", success_room
    expect(last_response.status).to eq(202)
  end

  it "should have 2 posts that correctly belong to the room" do
    post "/api/room/new", success_room
    expect(last_response.status).to eq(202)

    # TODO: rewrite here with FactoryGirl
    room_id = JSON.parse(last_response.body)['_id']
    msgs = [ { content: "Hello1", token: user.token },
             { content: "Hello2", token: user.token } ]
    msgs.each do |msg|
      post "/api/message/#{room_id}", msg
      expect(last_response.status).to eq(202)
    end

    messages_count = Message.where(room_id: room_id).count
    expect(messages_count).to eq(2)

    room_messages_count = Room.find(room_id).messages.count
    expect(room_messages_count).to eq(messages_count)
  end
end

describe "GET /api/room" do
  let(:admin) { create(:admin) }
  let(:room) { { name: "Room", token: admin.token } }
  let(:msgs) { [
    { content: "Hello1", token: admin.token },
    { content: "Hello2", token: admin.token }
  ] }

  it "should get messages of the room" do
    post "/api/room/new", room
    expect(last_response.status).to eq(202)

    room_id = JSON.parse(last_response.body)['_id']
    msgs.each do |msg|
      post "/api/message/#{room_id}", msg
      expect(last_response.status).to eq(202)
    end

    get "/api/room/#{room_id}/messages", { token: admin.token }
    expect(last_response.status).to eq(200)
    JSON.parse(last_response.body).each_with_index do |data, index|
      expect(data["content"]).to eq(msgs[index][:content])
    end
  end
end

describe "Room enter/leave port" do
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
  end

  # TODO Implement room check if the user successfully leaved
  it "should have an user leave the room" do
    post "/api/room/leave", param
    expect(last_response.status).to eq(202)
    expect(room.users.count).to eq(0)
  end
end

