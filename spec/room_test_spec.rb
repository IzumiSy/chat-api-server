require_relative "./spec_helper.rb"

describe "POST /api/room/new" do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  let(:success_room) {
    { name: "RoomSuccess",
      auth_token: admin.token }
  }
  let(:error_room) {
    { name: "RoomError",
      auth_token: user.token }
  }

  it "should NOT create a room without parameters" do
    post "/api/room/new"
    expect(last_response.status).to eq(400)
  end

  it "should NOT create a room by non-admin user" do
    pending "Authorization still not implemented"
    post "/api/room/new", error_room
    expect(last_response.status).to eq(401)
  end

  it "should create a new room with a name" do
    post "/api/room/new", success_room
    expect(last_response.status).to eq(202)
  end

  it "should have 2 posts that correctly belong to the channel" do
    post "/api/room/new", success_room
    expect(last_response.status).to eq(202)

    room_id = JSON.parse(last_response.body)['_id']
    params =
      [ { room_id: room_id, content: "Hello1" },
        { room_id: room_id, content: "Hello2" } ]
    params.each do |param|
      post "/api/message", param
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

  let(:room) {
    { name: "Room",
      auth_token: admin.token }
  }

  it "should get messages of the room" do
    post "/api/room/new", room
    expect(last_response.status).to eq(202)

    room_id = JSON.parse(last_response.body)['_id']
    params =
      [ { room_id: room_id, content: "Hello1" },
        { room_id: room_id, content: "Hello2" } ]
    messages = []
    params.each_with_index do |param, index|
      post "/api/message", param
      expect(last_response.status).to eq(202)
      messages[index] = param[:content]
    end

    get "/api/room/#{room_id}"
    expect(last_response.status).to eq(200)
    JSON.parse(last_response.body).each_with_index do |data, index|
      expect(data["content"]).to eq(params[index][:content])
    end
  end
end

describe "POST /api/room/enter" do
  let(:room) { { name: "Room" } }
  let(:user) { create(:user) }

  it "should have an user enter the room" do
    # TODO: Implementation
  end
end

describe "DELETE /api/room/leave" do
  let(:room) { { name: "Room" } }
  let(:user) { create(:user) }

  it "should have an user enter the room" do
    # TODO: Implementation
  end

  it "should have an user leave the room" do
    # TODO: Implementation
  end
end

