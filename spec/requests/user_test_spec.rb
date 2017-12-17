require_relative "../spec_helper.rb"

describe "GET /api/user/duplicate/:name", autodoc: true do
  let(:unique_user) { { name: "Justine" } }
  let!(:jonathan) { create(:Jonathan) }

  it "should get available with an unique name" do
    get "/api/user/duplicate/#{unique_user[:name]}"
    body = JSON.parse(last_response.body)
    expect(body["status"]).to eq(false);
    expect(last_response.status).to eq(200)
  end

  it "should NOT get available with a duplicated name" do
    get "/api/user/duplicate/#{jonathan[:name]}"
    body = JSON.parse(last_response.body)
    expect(body["status"]).to eq(true);
    expect(last_response.status).to eq(200)
  end
end

describe "POST /api/user/new", autodoc: true do
  let(:user) { { name: "test1" } }
  let(:error_user) { { name: "Jonathan" } }
  let!(:Lobby) { create(:Lobby) }
  let!(:Jonathan) { create(:Jonathan) }

  it "should NOT create a new user without name" do
    post "/api/user/new"
    expect(last_response.status).to eq(400)
  end

  it "should create a new user" do
    post "/api/user/new", user
    expect(last_response.status).to eq(200)
  end

  it "should NOT create a new user" do
    post "/api/user/new", error_user
    expect(last_response.status).to eq(400)
  end
end

describe "GET /api/user/:id", autodoc: true do
  let (:user) { create(:user) }

  it "should NOT get an error when invalid user id" do
    get "/api/user/12345",
      { format: "json" }, { "HTTP_AUTHORIZATION" => "Basic #{user.token}" }
    expect(last_response.status).to eq(404)
  end

  it "should get data of the user with valid user id" do
    get "/api/user/#{user.id}",
      { format: "json" }, { "HTTP_AUTHORIZATION" => "Basic #{user.token}" }
    body = JSON.parse(last_response.body)
    expect(last_response.status).to eq(200)
    expect(body["name"]).to eq(user.name);
  end
end

describe "GET /api/user/:id/room", autodoc: true do
  let(:user) { create(:user) }
  let(:room) { create(:room) }

  it "should get room data the user belongs to" do
    enter_room(room.id, user.token)

    get "/api/user/#{user.id}/room",
      { format: "json" }, { "HTTP_AUTHORIZATION" => "Basic #{user.token}" }
    expect(last_response.status).to eq(200)
  end

  it "should get 404 error with an invalid type" do
    get "/api/user/#{user.id}/nothing",
      { format: "json" }, { "HTTP_AUTHORIZATION" => "Basic #{user.token}" }
    expect(last_response.status).to eq(404)
  end
end
