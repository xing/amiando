require 'test_helper'

describe Amiando::Event do
  before do
    Amiando.api_key   = Amiando::TEST_KEY
    HydraCache.prefix = 'Event'
  end

  after do
    Amiando.api_key   = nil
    HydraCache.prefix = nil
  end

  describe 'find' do
    it 'finds an already existing event' do
      original = Amiando::Factory(:event, :identifier => 'wadus')
      Amiando.run

      event = Amiando::Event.find(original.id)
      Amiando.run

      event.id.must_equal original.id
      event.identifier.must_equal 'wadus'
    end
  end

  describe 'exists' do
    it 'checks if an event an already exists' do
      original = Amiando::Factory(:event, :identifier => 'wadus')
      Amiando.run

      exists = Amiando::Event.exists?('wadus')
      Amiando.run

      exists.result.must_equal true
    end
  end

  describe 'create' do
    it 'creates an event wit valid parameters passed' do
      event = Amiando::Event.create(
        :host_id       => Amiando::TEST_USER.id,
        :title         => 'Secret title',
        :country       => 'es',
        :selected_date => Time.at(0)
      )

      Amiando.run

      event.id.wont_be_nil
      event.success.must_equal true
    end
  end

  describe 'update' do
    it 'updates the event' do
      event = Amiando::Factory.create(:event, :title => 'wadus',
        :identifier => "event-identifier-update-#{HydraCache.revision}")

      Amiando::Event.update(event.id, :title => 'wadus 2')
      Amiando.run

      event = Amiando::Event.find(event.id)
      Amiando.run

      event.title.must_equal 'wadus 2'
    end
  end

  describe 'find_all_by_user_id' do
    it 'fetches event ids for a user' do
      event = Amiando::Factory.create(:event, :identifier => "event-identifier-find-all-#{HydraCache.revision}")

      all = Amiando::Event.find_all_by_user_id(Amiando::TEST_USER.id)
      Amiando.run

      all.result.must_include event.id
    end
  end

  describe 'activate' do
    it "returns errors if it can't be activated" do
      event  = Amiando::Factory.create(:event, :identifier => "event-identifier-activate-#{HydraCache.revision}")

      activated = Amiando::Event.activate(event.id)
      Amiando.run

      activated.result.must_equal false
      activated.errors.wont_be_empty
    end

    ##
    # To be implemented when we can do everything necessary to activate an event
    # (create ticket categories, etc).
    # it 'activates the event' do
    # end
  end

  describe 'delete' do
    it 'deletes the event' do
      event = Amiando::Factory.create(:event, :identifier => "event-identifier-#{HydraCache.revision}")

      deleted = Amiando::Event.delete(event.id)
      Amiando.run

      deleted.result.must_equal true

      exists = Amiando::Event.exists?(event.id)
      Amiando.run

      exists.result.must_equal false
    end
  end

  describe 'search' do
    it 'finds events by identifier' do
      event = Amiando::Factory(:event, :identifier => 'waduswadus1234')
      Amiando.run

      search = Amiando::Event.search(:identifier => 'waduswadus1234')
      Amiando.run

      search.result.must_include event.id
    end

    it 'finds events by title' do
      event = Amiando::Factory(:event, :title => 'Long title wadus bang bang bang')
      Amiando.run

      search = Amiando::Event.search(:title => 'Long title wadus bang bang bang')
      Amiando.run

      search.result.must_include event.id
    end

    it 'raises an error if more than one or no search option passed' do
      lambda { Amiando::Event.search :title => 'a', :identifier => 'e' }.must_raise ArgumentError
      lambda { Amiando::Event.search({})}.must_raise ArgumentError
    end
  end
end
