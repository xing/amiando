require 'test_helper'

describe Amiando::PaymentType do
  before do
    HydraCache.prefix = 'PaymentType'
  end

  after do
    HydraCache.prefix = nil
  end

  let(:event) { Amiando::Factory.create(:event) }

  describe 'create' do
    it 'creates a payment type given valid attributes' do
      payment_type = Amiando::PaymentType.create(event.id, :invoice)

      Amiando.run

      payment_type.result.wont_be_nil
    end

    it 'handles errors properly' do
      payment_type = Amiando::PaymentType.create(event.id, :cc)
      Amiando.run

      payment_type.result.must_equal false
      payment_type.errors.must_include "com.amiando.api.rest.paymentType.PaymentTypeAlreadyExists"
    end
  end

  describe 'find' do
    it 'finds a payment type given the id' do
      payment_id = Amiando::PaymentType.sync_create(event.id, :invoice).result

      payment = Amiando::PaymentType.find(payment_id)
      Amiando.run

      payment.id.must_equal payment_id
    end
  end

  describe 'find_all_by_event_id' do
    it 'finds the payment types given an event' do
      payment_id = Amiando::PaymentType.sync_create(event.id, :invoice).result
      payment_type = Amiando::PaymentType.sync_find(payment_id)

      payment_types = Amiando::PaymentType.find_all_by_event_id(event.id)
      Amiando.run

      payment_types.result.must_include payment_type
    end
  end
end
