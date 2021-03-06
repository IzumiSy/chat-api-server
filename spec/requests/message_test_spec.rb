require_relative "../spec_helper.rb"

describe "POST /api/message/:room_id" do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:invalid_message) { { content: "Hello" } }

  it "should get an error when no params" do
    post "/api/message/#{room.id}", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(400)
  end

  # it "should get an error in posting a message to unexisted room" do
  #   post "/api/message/12345", invalid_message, 'rack.session' => { user_id: user.id }
  #   expect(last_response.status).to eq(404)
  # end
end

