require 'test_helper'

describe Amiando::User do
  before do
    Amiando.api_key   = Amiando::TEST_KEY
    HydraCache.prefix = 'User'
  end

  after do
    Amiando.api_key   = nil
    HydraCache.prefix = nil
  end

  describe 'create' do
    it 'creates a user with valid parameters passed' do
      user = Amiando::User.create(
        :first_name => 'Jorge',
        :last_name  => 'Llop',
        :username   => "jorgellop-#{HydraCache.revision}@example.com",
        :password   => '123456',
        :language   => 'es'
      )
      Amiando.run

      user.id.wont_be_nil
      user.success.must_equal true
    end
  end

  describe 'exists?' do
    it "will return if the user exists" do
      username = "jorgellop-exists-#{HydraCache.revision}@example.com"
      user = Amiando::Factory(:user, :username => username)
      Amiando.run

      exists = Amiando::User.exists?(username)
      Amiando.run

      exists.result.must_equal true
    end
  end
end
