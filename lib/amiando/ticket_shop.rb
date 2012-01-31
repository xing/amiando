module Amiando

  ##
  # From the documentation:
  #
  # http://developers.amiando.com/index.php/REST_API_TicketShops
  #
  #   A ticketshop will automatically be created when you create an event.
  #   That's why you only have read and update access, but no create access.
  #   If you delete the related event, the ticketshop will also be deleted.
  #
  class TicketShop < Resource
    ##
    # Get the ticket shop of an event.
    #
    # @param event id
    #
    # @return [TicketShop] the event's ticketshop
    def self.find(event_id)
      object = new
      get object, "api/event/#{event_id}/ticketShop"

      object
    end

    ##
    # Updates the ticket shop.
    #
    # @param event_id
    # @param [Hash] attributes
    #
    # @return [Boolean] deferred object indicating the result of the update.
    def self.update(event_id, attributes)
      object = Boolean.new('success')
      post object, "/api/event/#{event_id}/ticketShop", :params => attributes

      object
    end

    protected

    def populate(response_body)
      extract_attributes_from(response_body, 'ticketShop')
    end
  end
end
