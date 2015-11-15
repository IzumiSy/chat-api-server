require_relative "./spec_helper.rb"

describe "GET /user" do
  it "should get users" do
    get "/user"
    expect(last_response.status).to eq(200)
  end
end

describe "POST /user/signup" do
  it "should not make users sign up without params" do
    post "/user/signup"
    expect(last_response.status).to eq(400)
  end
end

describe "POST user/signin" do
  it "should not make users sign in without params" do
    post "/user/signin"
    expect(last_response.status).to eq(400)
  end
end

