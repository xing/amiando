require 'test_helper'

describe Amiando::TicketType do
  before do
    HydraCache.prefix = 'TicketType'
  end

  after do
    HydraCache.prefix = nil
  end

  let(:event) { Amiando::Factory.create(:event, :country => 'de') }

  describe 'create' do
    it 'handles already existing types' do
      ticket_type = Amiando::TicketType.create(event.id, :paper)
      Amiando.run

      ticket_type.result.must_equal false
      ticket_type.errors.must_include "com.amiando.api.rest.ticketType.TicketTypeAlreadyExists"
    end

    it 'handles non available ticket types' do
      ticket_type = Amiando::TicketType.create(event.id, :badge)
      Amiando.run

      ticket_type.result.must_equal false
      ticket_type.errors.must_include "com.amiando.api.rest.ticketType.TicketTypeNotAllowed"
    end

    it 'should accept a Hash as a param' do
      ticket_type = Amiando::TicketType.create(event.id, :type => :eticket)
      ticket_type.request.params.must_equal(:type => "TICKETTYPE_ETICKET")
    end

    it 'should accept a ticket string as a param' do
      ticket_type = Amiando::TicketType.create(event.id, :type => "TICKETTYPE_ETICKET")
      ticket_type.request.params.must_equal(:type => "TICKETTYPE_ETICKET")
    end

    it 'should accept a short string as a param' do
      ticket_type = Amiando::TicketType.create(event.id, "ETICKET")
      ticket_type.request.params.must_equal(:type => "TICKETTYPE_ETICKET")
    end
  end

  describe 'find' do
    it 'finds a ticket type given the id' do
      ticket_types = Amiando::TicketType.sync_find_all_by_event_id(event.id)

      ticket_type_id = ticket_types.result.ticket_types.first.id

      ticket_type = Amiando::TicketType.find(ticket_type_id)
      Amiando.run

      ticket_type.id.must_equal ticket_type_id
    end
  end

  describe 'find_all_by_event_id' do
    it 'finds the ticket types given an event' do
      ticket_types = Amiando::TicketType.find_all_by_event_id(event.id)
      Amiando.run

      ticket_types.result.ticket_types.each { |t| t.must_be_kind_of(Amiando::TicketType) }
      ticket_types.result.available_ticket_types.must_equal ["TICKETTYPE_PAPER", "TICKETTYPE_ETICKET"]
    end
  end

  describe 'update' do
    it 'updates the given attributes' do
      event = Amiando::Factory.create(:event, :name => "ticket-type-update-#{HydraCache.revision}")
      ticket_types = Amiando::TicketType.sync_find_all_by_event_id(event.id)
      ticket_type_id = ticket_types.result.ticket_types.first.id

      update = Amiando::TicketType.update(ticket_type_id, :active => false)
      Amiando.run

      update.result.must_equal true

      ticket_type = Amiando::TicketType.sync_find(ticket_type_id)
      ticket_type.active.must_equal false
    end
  end

  describe 'type' do
    it 'returns the amiando type string' do
      ticket_type = Amiando::TicketType.new(:type => 'TICKETTYPE_ETICKET')
      ticket_type.type.must_equal 'TICKETTYPE_ETICKET'
    end
  end

end
