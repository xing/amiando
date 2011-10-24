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
