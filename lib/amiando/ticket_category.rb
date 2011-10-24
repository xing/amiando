module Amiando
  # http://developers.amiando.com/index.php/REST_API_TicketCategories
  class TicketCategory < Resource
    map :sale_start,         :saleStart, :type => :time
    map :sale_end,           :saleEnd,   :type => :time
    map :reserved_count,     :reservedCount
    map :min_sell,           :minSell
    map :max_sell,           :maxSell
    map :default_value,      :defaultValue
    map :min_sell_required,  :minSellRequired
    map :ticket_description, :ticketDescription
    map :display_price,      :displayPrice
    map :display_quantity,   :displayQuantity
    map :price_editable,     :priceEditable

    ##
    # Creates a ticket category for an event
    # The returned object only contains the id or errors.
    #
    # @param event_id
    # @param [Hash] attributes
    def self.create(event_id, attributes)
      object = new
      post object, "api/event/#{event_id}/ticketCategory/create",
        :params => attributes,
        :populate_method => :populate_create

      object
    end

    ##
    # Update  a ticket_category
    #
    # @param [Hash] attributes
    def self.update(ticket_category_id, attributes)
      object = Result.new do |response_body, result|
        if response_body['success']
          true
        else
          result.errors = response_body['errors']
          false
        end
      end

      post object, "api/ticketCategory/#{ticket_category_id}", :params => attributes

      object
    end

  end
end
