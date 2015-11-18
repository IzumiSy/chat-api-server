require_relative "./spec_helper.rb"

describe "POST /api/room/new" do
  let(:room1) { { name: "Room1" } }
  let(:room2) { { name: "Room2" } }


  it "should get an error in creating error without a name" do
    post "/api/room/new"
    expect(last_response.status).to eq(400)
  end

  it "should create a new room with a name" do
    post "/api/room/new", room1
    expect(last_response.status).to eq(202)
  end

  it "should have 2 posts to the channel" do
    post "/api/room/new", room2
    expect(last_response.status).to eq(202)

    room_id = JSON.parse(last_response.body)['_id']
    params =
      [ { room_id: room_id, content: "Hello1" },
        { room_id: room_id, content: "Hello2" } ]
    params.each do |param|
      post "/api/message", param
      expect(last_response.status).to eq(202)
    end

    message_count = Message.where(room_id: room_id).count
    expect(message_count).to eq(2)
  end
end

