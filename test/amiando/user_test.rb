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
      user = Amiando::Factory.create(:user, :username => username)

      exists = Amiando::User.exists?(username)
      Amiando.run

      exists.result.must_equal true
    end
  end

  describe 'logout' do
    it 'logs out a user if exists' do
      username = "jorgellop-logout-test-#{HydraCache.revision}@example.com"
      user = Amiando::Factory.create(:user, :username => username)

      logout = Amiando::User.logout(user.id)
      Amiando.run

      logout.result.must_equal true
    end
  end

  describe 'update' do
    it 'updates a user given the id' do
      username = "jorgellop-update-#{HydraCache.revision}@example.com"
      user = Amiando::Factory.create(:user, :username => username)

      update = Amiando::User.update(user.id, :telephone => "0034666666666")
      Amiando.run

      update.result.must_equal true
    end
  end

  describe 'find' do
    it 'finds a user given the id' do
      username = "jorgellop-find-#{HydraCache.revision}@example.com"
      user = Amiando::Factory.create(:user, :username => username)

      found = Amiando::User.find(user.id)
      Amiando.run

      found.must_equal user
    end
  end

  describe 'delete' do
    it 'should delete a user' do
      username = "jorgellop-delete-#{HydraCache.revision}@example.com"
      user = Amiando::Factory.create(:user, :username => username)

      deleted = Amiando::User.delete(user.id)
      Amiando.run

      deleted.result.must_equal true
    end
  end
end
