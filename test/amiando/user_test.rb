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

  describe 'find_by_username' do
    it 'should return the user id when found' do
      username = "jorgellop-find_by_username-#{HydraCache.revision}@example.com"
      user = Amiando::Factory.create(:user, :username => username)

      result = Amiando::User.find_by_username(username)
      Amiando.run

      result.result.must_equal user.id
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

  describe 'request_permission' do
    it 'should be successful given the right password' do
      username = "jorgellop-request-permission-#{HydraCache.revision}@example.com"
      user = Amiando::Factory(:user, :username => username, :password => '12345')
      key = Amiando::Factory(:api_key)
      Amiando.run

      Amiando.api_key = key.key
      permission = Amiando::User.request_permission(user.id, '12345')
      Amiando.run

      permission.result.must_equal true
    end

    it 'should not be successful given the wrong password' do
      username = "jorgellop-request-permission-#{HydraCache.revision}@example.com"
      user = Amiando::Factory(:user, :username => username, :password => '12345')
      key = Amiando::Factory(:api_key)
      Amiando.run

      Amiando.api_key = key.key
      permission = Amiando::User.request_permission(user.id, 'wrong password')
      Amiando.run

      permission.result.must_equal false
      permission.errors.must_include "com.amiando.api.rest.InvalidPassword"
    end
  end
end
