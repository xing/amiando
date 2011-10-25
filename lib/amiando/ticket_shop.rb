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

    map :ticket_base_fee, :ticketBaseFee
    map :product_disagio, :productDisagio
    map :fee_inclusive, :feeInclusive
    map :shipment_fee_inclusive, :shipmentFeeInclusive
    map :sales_tax, :salesTax
    map :available_limit, :availableLimit
    map :show_available_tickets, :showAvailableTickets
    map :cancelation_possible, :cancelationPossible
    map :num_tickets_sold, :numTicketsSold
    map :total_income, :totalIncome
    map :total_fees, :totalFees
    map :collect_user_data, :collectUserData
    map :max_possible_number_of_participants, :maxPossibleNumberOfParticipants
    map :num_tickets_checked, :numTicketsChecked
    map :vat_id, :vatId

    ##
    # Get the ticket shop of an event.
    #
    # @param event id
    #
    # @return [TicektShop] the event's ticketshop
    def self.find(event_id)
      object  = new
      request = get object, "api/event/#{event_id}/ticketShop"

      object
    end

    ##
    # Updates the ticket shop.
    #
    # @param [String] username
    #
    # @return [Boolean] deferred object indicating the result of the update.
    def self.update(event_id, attributes)
      object  = Boolean.new('success')
      request = post object, "/api/event/#{event_id}/ticketShop", :params => map_params(attributes)

      object
    end


    private

    def populate(response_body)
      extract_attributes_from(response_body, 'ticketShop')
    end
  end
end
