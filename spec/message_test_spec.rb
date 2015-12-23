require_relative "./spec_helper.rb"

describe "POST /api/message" do
  let(:user) { create(:user) }
  let(:message1) {
    { room_id: 0,
      content: "Hello",
      token: user.token }
  }

  it "should get an error when no params" do
    post "/api/message"
    expect(last_response.status).to eq(400)
  end

  it "should get an error in posting a message to unexisted room" do
    post "/api/message", message1
    expect(last_response.status).to eq(404)
  end
end

