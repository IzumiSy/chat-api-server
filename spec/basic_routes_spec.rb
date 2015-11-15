require_relative "./spec_helper.rb"

describe "GET /" do
  it "should get nothing with 200" do
    get "/user"
    expect(last_response.status).to eq(200)
  end
end
