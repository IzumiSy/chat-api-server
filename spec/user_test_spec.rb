require_relative "./spec_helper.rb"

describe "POST /api/user/new" do
  let(:user1) { { name: "test1" } }

  it "should NOT create a new user without name" do
    post "/api/user/new"
    expect(last_response.status).to eq(400)
  end

  it "should create a new user" do
    post "/api/user/new", user1
    expect(last_response.status).to eq(202)
  end
end

describe "GET /api/user/usable" do

end
