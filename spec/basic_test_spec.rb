require_relative "./spec_helper.rb"

ENV['ADMIN_PASS'] = 'testpass'

describe "POST /api/admin/auth" do
  let(:env_hash) { ENV["ADMIN_PASS"] }
  let(:success_hash) { Digest::MD5.hexdigest('testpass') }
  let(:error_hash) { Digest::MD5.hexdigest('testpassee') }

  it "should get auth_token" do
    post 'api/admin/auth', { auth_hash: success_hash }
    expect(last_response.status).to eq(200)
  end

  it "should NOT get auth_token with incorrect password" do
    post 'api/admin/auth', { auth_hash: error_hash }
    expect(last_response.status).to eq(401)
  end

  it "should NOT get auth_token with empty parameter" do
    post 'api/admin/auth', { auth_hash: "" }
    expect(last_response.status).to eq(400)
  end
end
