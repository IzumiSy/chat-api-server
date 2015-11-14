require_relative "./spec_helper.rb"

describe "GET /user" do
  it "should get users" do
    get "/user"
  end
end

describe "POST /user/signup" do
  it "should make users sign up" do
    post "/users/signup"
  end
end

describe "POST user/signin" do
  it "should make users sign in" do
    post "/users/signin"
  end
end

