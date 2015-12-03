require "pry"

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
  let(:inavailable_name) { "jonathan" }
  let(:available_name) { "bob" }

  before do
    post "/api/user/new", user
    expect(last_response.status).to eq(202)
  end

  it "should get TRUE if the user who has the same name already exists" do
    get "/api/user/usable/#{inavailable_name}"
    expect(last_response.status).to eq(200)
    availability_stat = JSON.parse(last_response.body)
    expect(availability_stat["status"]).to eq(false)
  end

  it "should get FALSE if the user who has the same name doesnt exist" do
    get "/api/user/usable/#{available_name}"
    expect(last_response.status).to eq(200)
    availability_stat = JSON.parse(last_response.body)
    expect(availability_stat["status"]).to eq(true)
  end
end
