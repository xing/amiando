module Amiando

  ##
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
      object = Result.new
      post object, "api/ticketCategory/#{ticket_category_id}", :params => attributes

      object
    end

    ##
    # Find a ticket category.
    #
    # @param ticket category id
    #
    # @return [TicketCategory]
    def self.find(ticket_category_id)
      object = new
      get object, "api/ticketCategory/#{ticket_category_id}"

      object
    end

    ##
    # @param event id
    # @param [Symbol]
    #   :ids if you only want to fetch the ids.
    #   :full if you want the whole objects
    #
    # @return [Result] with all the ticket category ids for this event.
    def self.find_all_by_event_id(event_id, type = :ids)
      object = Result.new do |response_body, result|
        if response_body['success']
          if type == :ids
            response_body['ticketCategories']
          else
            response_body['ticketCategories'].map do |category|
              new(category)
            end
          end
        else
          result.errors = response_body['errors']
          false
        end
      end

      get object, "/api/event/#{event_id}/ticketCategories", :params => {:resultType => type}

      object
    end

    private

    def populate(response_body)
      extract_attributes_from(response_body, 'ticketCategory')
    end
  end
end
