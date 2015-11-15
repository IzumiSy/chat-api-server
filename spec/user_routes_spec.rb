require_relative "./spec_helper.rb"

describe "GET /api/:users" do
  it "should get nothing without id param" do
    get "/api/users"
    expect(last_response.status).to eq(404)
  end

  it "should get an error in trying to fetch an undefined user " do
   get "/api/users/100"
   expect(last_response.status).to eq(400)
  end
end

describe "POST /api/user/signup" do
  let(:signup_params) {
    { name: "Jonathan",
      email: "jonathan@test.com" }
  }

  it "should NOT make users sign up without params" do
    post "/api/user/signup"
    expect(last_response.status).to eq(400)
  end

  it "should make users sign up with params" do
    post "/api/user/signup", signup_params
    expect(last_response.status).to eq(202)

    userId = JSON.parse(last_response.body)['_id']
    get "/api/users/#{userId}"
    expect(last_response.status).to eq(200)
  end
end

describe "POST /api/user/signin" do
  it "should not make users sign in without params" do
    post "/api/user/signin"
    expect(last_response.status).to eq(400)
  end
end

