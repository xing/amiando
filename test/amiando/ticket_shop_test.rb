require 'test_helper'

describe Amiando::TicketShop do
  before do
    Amiando.api_key   = Amiando::TEST_KEY
    HydraCache.prefix = 'TicketShop'
  end

  after do
    Amiando.api_key   = nil
    HydraCache.prefix = nil
  end

  describe 'find' do
    it 'gets the ticket shop of an event' do
      event = Amiando::Factory.create(:event, :identifier => "event-ticketshop-find-#{HydraCache.revision}")

      ticket_shop = Amiando::TicketShop.find(event.id)
      Amiando.run

      ticket_shop.id.wont_be_nil
      ticket_shop.ticket_base_fee.wont_be_nil
      ticket_shop.fee_inclusive.wont_be_nil
    end
  end

  describe 'update' do
    it 'updates the values of the ticketshop' do
      event = Amiando::Factory.create(:event, :identifier => "event-ticketshop-update-#{HydraCache.revision}")

      update = Amiando::TicketShop.update(event.id, :fee_inclusive => true, :shipment_fee_inclusive => true, :currency => 'USD')
      Amiando.run

      ticket_shop = Amiando::TicketShop.find(event.id)
      Amiando.run

      ticket_shop.fee_inclusive.must_equal true
      ticket_shop.shipment_fee_inclusive.must_equal true
      ticket_shop.currency.must_equal 'USD'
    end
  end
end
