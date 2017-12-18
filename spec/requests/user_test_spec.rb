require_relative "../spec_helper.rb"

describe "POST /api/user/new" do
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

describe "GET /api/user/:id" do
  let(:user) { create(:user) }

  it "should get an error when invalid user id" do
    get "/api/user/12345", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(404)
  end

  it "should get data of the user with valid user id" do
    get "/api/user/#{user.id}", {}, 'rack.session' => { user_id: user.id }
    body = JSON.parse(last_response.body)
    expect(last_response.status).to eq(200)
    expect(body["name"]).to eq(user.name);
  end
end

describe "GET /api/user/:id/room" do
  let(:user) { create(:user) }
  let(:room) { create(:room) }

  it "should get room data the user belongs to" do
    enter_room(room.id, user)

    get "/api/user/#{user.id}/room", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(200)
  end

  it "should get 404 error with an invalid type" do
    get "/api/user/#{user.id}/nothing", {}, 'rack.session' => { user_id: user.id }
    expect(last_response.status).to eq(404)
  end
end
