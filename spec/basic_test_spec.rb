require_relative "./spec_helper.rb"

ENV['ADMIN_PASS'] = 'testpass'

describe "POST /api/admin/auth" do
  let(:redis) { Helpers.redis_connect() }
  let(:user) { create(:user) }

  let(:success_param) {
    { auth_hash: Digest::MD5.hexdigest('testpass'),
      user_id: user.id }
  }
  let(:undefined_user_param) {
    { auth_hash: Digest::MD5.hexdigest('testpass'),
      user_id: "12345" }
  }
  let(:error_param) {
    { auth_hash: Digest::MD5.hexdigest('testpassee'),
      user_id: user.id }
  }

  it "should get auth_token" do
    post 'api/admin/auth', success_param
    status = last_response.status
    is_admin = JSON.parse(last_response.body)["is_admin"]
    expect(status).to eq(200)
    expect(is_admin).to eq(true)
  end

  it "should NOT update an user with undefined user_id" do
    post 'api/admin/auth', undefined_user_param
    expect(last_response.status).to eq(500)
    expect(last_response.body).to eq("User Not Found")
  end

  it "should NOT get auth_token with incorrect password" do
    post 'api/admin/auth', error_param
    expect(last_response.status).to eq(401)
  end

  it "should NOT get auth_token with empty parameters" do
    post 'api/admin/auth'
    expect(last_response.status).to eq(400)
  end
end
