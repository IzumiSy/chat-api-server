require_relative "./spec_helper.rb"

describe "POST /api/user/usable" do
  let(:user) { create(:user) }
  let(:error_name) { { name: user.name } }
  let(:success_name) { { name: "bob" } }

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

describe "POST /api/user/new" do
  let(:user) { { name: "test1" } }

  it "should NOT create a new user without name" do
    post "/api/user/new"
    expect(last_response.status).to eq(400)
  end

  it "should create a new user" do
    post "/api/user/new", user
    expect(last_response.status).to eq(202)
  end
end

describe "GET /api/user/:id" do
  let (:user) { create(:user) }

  it "should NOT get an error when invalid user id" do
    get "/api/user/12345", { token: user.token }
    expect(last_response.status).to eq(404)
  end

  it "should get data of the user with valid user id" do
    get "/api/user/#{user.id}", { token: user.token }
    body = JSON.parse(last_response.body)
    expect(last_response.status).to eq(200)
    expect(body["name"]).to eq(user.name);
  end
end

describe "GET /api/user/:id/room" do
  let(:user) { create(:user) }
  let(:room) { create(:room) }

  it "should get room data the user belongs to" do
    enter_room(room.id, user.token)

    get "/api/user/#{user.id}/room", { token: user.token }
    expect(last_response.status).to eq(200)
  end
end
