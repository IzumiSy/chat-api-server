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
  let(:user) { { name: "jonathan" } }
  let(:user_name) { "jonathan" }

  it "should get true if the user whose name is the same already exists" do
    post "/api/user/new", user
    expect(last_response.status).to eq(202)

    get "/api/user/usable&name=#{user_name}"
    expect(last_response.status).to eq(200)
  end
end
