require "test_helper"

describe Amiando::TicketCategory do
  before do
    Amiando.api_key = Amiando::TEST_KEY
    HydraCache.prefix = 'TicketCategory'
  end

  after do
    Amiando.api_key = nil
    HydraCache.prefix = nil
  end

  describe 'create' do
    it 'should create a ticket category given valid required parameters' do
      event = Amiando::Factory.create(:event)
      ticket_category = Amiando::TicketCategory.create(event.id,
        :name      => "Name",
        :price     => "50",
        :available => "1"
      )

      Amiando.run

      ticket_category.id.wont_be_nil
      ticket_category.success.must_equal true
    end

    it 'should return errors if invalid data given' do
      ticket_category = Amiando::Factory.create(:ticket_category, :name => "")

      ticket_category.success.must_equal false
      ticket_category.errors.must_include "com.amiando.api.rest.MissingParam.name"
    end
  end

  describe 'update' do
    it 'should update a ticket category given valid parameters' do
      ticket_category = Amiando::Factory.create(:ticket_category)

      update = Amiando::TicketCategory.update(ticket_category.id, :name => "New name")
      Amiando.run

      update.result.must_equal true
    end

    it 'should return errors if invalid data given' do
      ticket_category = Amiando::Factory.create(:ticket_category)

      update = Amiando::TicketCategory.update(ticket_category.id, :name => "")
      Amiando.run

      update.result.must_equal false
      update.errors.must_include "com.amiando.TicketCategory.NameMissing"
    end
  end

  describe 'find' do
    it 'finds a ticket category given the id' do
      ticket_category = Amiando::Factory.create(:ticket_category)
      found = Amiando::TicketCategory.find(ticket_category.id)
      Amiando.run

      found.must_equal ticket_category
    end
  end

  describe 'find_all_by_event_id' do
    it 'fetches ticket category ids for the event' do
      event = Amiando::Factory.create(:event)
      ticket_category = Amiando::Factory.create(:ticket_category, :event => event)

      found = Amiando::TicketCategory.find_all_by_event_id(event.id)
      Amiando.run

      found.result.must_include ticket_category.id
    end

    it 'fetches ticket categories for the event' do
      event = Amiando::Factory.create(:event)
      ticket_category = Amiando::Factory.create(:ticket_category, :event => event)

      found = Amiando::TicketCategory.find_all_by_event_id(event.id, :full)
      Amiando.run

      found.result.must_include ticket_category
    end
  end
end
