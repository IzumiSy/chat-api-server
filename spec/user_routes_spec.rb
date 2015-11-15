require_relative "./spec_helper.rb"

describe "POST /api/user/signup" do
  let(:signup_params) {
    { name: "Jonathan",
      email: "jonathan@test.com" }
  }

  it "should NOT make users sign up without params" do
    post "/user/signup"
    expect(last_response.status).to eq(400)
  end

  it "should make users sign up with params" do
    post "/api/user/signup", signup_params
    expect(last_response.status).to eq(202)
  end
end

describe "POST /api/user/signin" do
  it "should not make users sign in without params" do
    post "/api/user/signin"
    expect(last_response.status).to eq(400)
  end
end

