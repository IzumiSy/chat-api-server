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

describe "POST /api/user/usable" do
  let(:user) { { name: "jonathan" } }
  let(:error_name) { { name: "jonathan" } }
  let(:success_name) { { name: "bob" } }

  before do
    post "/api/user/new", user
    expect(last_response.status).to eq(202)
  end

  it "should get FALSE if the user who has the same name already exists" do
    post "/api/user/usable", error_name
    expect(last_response.status).to eq(200)
    is_name_available = JSON.parse(last_response.body)["status"]
    expect(is_name_available).to eq(false)
  end

  it "should get TRUE if the user who has the same name doesnt exist" do
    post "/api/user/usable", success_name
    expect(last_response.status).to eq(200)
    is_name_available = JSON.parse(last_response.body)["status"]
    expect(is_name_available).to eq(true)
  end
end
