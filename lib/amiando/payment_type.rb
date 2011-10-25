module Amiando
  class PaymentType < Resource

#     /event/{id}/paymentTypes <-- all paymentTypes of the event
# /event/{id}/paymentType/create <-- creating a new paymentType
# /paymentType/{id} <-- returns the paymentType (used for udpates etc)

# PaymentType has just the following three variables:

# Id
# Type (String of the following: {PAYMENT_TYPE_ELV, PAYMENT_TYPE_CC, PAYMENT_TYPE_INVOICE, PAYMENT_TYPE_PREPAYMENT, PAYMENT_TYPE_PP, PAYMENT_TYPE_ONLOCATION}) [CC = CreditCard, PP = PayPal]
# Active (boolean)
    ##
    # Create a payment type for an event
    #
    # @param event id
    # @param [Type] Type (String of the following:
    #   PAYMENT_TYPE_ELV, PAYMENT_TYPE_CC, PAYMENT_TYPE_INVOICE, PAYMENT_TYPE_PREPAYMENT,
    #   PAYMENT_TYPE_PP, PAYMENT_TYPE_ONLOCATION) [CC = CreditCard, PP = PayPal]
    #   It will also accept :cc, :invoice, etc and convert them appropiately
    #
    def self.create(event_id, type)
      unless type =~ /payment_type_\w+/i
        type = "payment_type_#{type}"
      end

      object = Result.new do |response_body, result|
        if response_body['success']
          response_body['id']
        else
          result.errors = response_body['errors']
          false
        end
      end

      post object, "api/event/#{event_id}/paymentType/create", :params => { :type => type.upcase }

      object
    end

    def self.find_all_by_event_id(event_id)
      object = Result.new do |response_body, result|
        if response_body['success']
          response_body['results']['paymentTypes'].map do |payment_type|
            new(payment_type)
          end
        else
          result.errors = response_body['errors']
          false
        end
      end

      get object, "api/event/#{event_id}/paymentTypes"

      object
    end

    def self.find(payment_type_id)
      object = new

      get object, "api/paymentType/#{payment_type_id}"

      object
    end

    protected

    def populate(response_body)
      extract_attributes_from(response_body, 'paymentType')
    end
  end
end
