require 'test_helper'

describe Amiando::Partner do
  before do
    HydraCache.prefix = 'Partner'
  end

  after do
    HydraCache.prefix = nil
  end

  describe 'create' do
    it 'creates a partner successfully' do
      api_key = Amiando::Factory.create(:api_key, :name => "partner-create-#{HydraCache.revision}")
      Amiando.with_key api_key.key do
        username = "partner_create-#{HydraCache.revision}@example.com"
        user     = Amiando::Factory.create(:user, :username => username)
        partner  = Amiando::Partner.create(
          :admin_id        => user.id,
          :name            => "Partner name",
          :language        => "en",
          :default_country => "ES"
        )
        Amiando.run

        partner.id.wont_be_nil
      end
    end

    it 'handles errors' do
      partner = Amiando::Partner.create(
        :admin_id        => nil,
        :name            => "Partner name",
        :language        => "en",
        :default_country => "ES"
      )
      Amiando.run

      partner.errors.wont_be_empty
    end
  end

  describe 'update' do
    it 'updates the object' do
      api_key = Amiando::Factory.create(:api_key, :name => "partner-update-#{HydraCache.revision}")
      Amiando.with_key api_key.key do
        username = "partner_update-#{HydraCache.revision}@example.com"
        user     = Amiando::Factory.create(:user, :username => username)
        partner  = Amiando::Partner.create(
          :admin_id        => user.id,
          :name            => "Partner name",
          :language        => "en",
          :default_country => "ES"
        )
        Amiando.run

        update = Amiando::Partner.update(partner.id, :name => 'wadus')
        Amiando.run

        update.result.must_equal true
      end
    end
  end

  describe 'find' do
    it 'finds the object' do
      api_key = Amiando::Factory.create(:api_key, :name => "partner-find-#{HydraCache.revision}")
      Amiando.with_key api_key.key do
        username = "partner_find-#{HydraCache.revision}@example.com"
        user     = Amiando::Factory.create(:user, :username => username)
        partner  = Amiando::Partner.create(
          :admin_id        => user.id,
          :name            => "to be found",
          :language        => "en",
          :default_country => "ES"
        )
        Amiando.run

        found = Amiando::Partner.find(partner.id)
        Amiando.run

        found.must_equal partner
        found.name.must_equal "to be found"
      end
    end
  end

end
