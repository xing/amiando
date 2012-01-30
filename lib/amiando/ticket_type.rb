module Amiando
  class TicketType < Resource

    ##
    # Create a ticket type for an event
    #
    # @param event_id
    # @param type string or symbol of the following:
    #   * TICKETTYPE_ETICKET
    #   * TICKETTYPE_PAPER
    #   * TICKETTYPE_BADGE
    #   * TICKETTYPE_CONFIRMATION
    #   * TICKETTYPE_ONSITE
    #
    #   It will also accept :eticket, :paper, etc and convert them appropriately
    #
    def self.create(event_id, type)
      type = type[:type] if type.is_a?(Hash)

      unless type =~ /^tickettype_\w+/i
        type = "tickettype_#{type}"
      end

      object = Result.new do |response_body, result|
        result.errors = response_body['errors']
        response_body['id'] || false
      end

      post object, "api/event/#{event_id}/ticketType/create", :params => { :type => type.upcase }

      object
    end

    ##
    # Find all Ticket Types of an event
    #
    # @param event_id
    #
    # @return [Result] with the list of ticket types for that event.
    def self.find_all_by_event_id(event_id)
      object = Result.new do |response_body, result|
        if response_body['success']
          ticket_types = response_body['results']['ticketTypes'].map do |ticket_type|
            new(ticket_type)
          end

          available = response_body['results']['availableTicketTypes']

          OpenStruct.new(:ticket_types => ticket_types,
                         :available_ticket_types => available)
        else
          result.errors = response_body['errors']
          false
        end
      end

      get object, "api/event/#{event_id}/ticketTypes"

      object
    end

    ##
    # Find a Ticket Type
    #
    # @param ticket_type_id
    #
    # @return [TicketType] the ticket type with that id
    def self.find(ticket_type_id)
      object = new
      get object, "api/ticketType/#{ticket_type_id}"

      object
    end

    ##
    # Update a ticket type
    #
    # @param ticket_type_id
    # @param [Hash] attributes attributes to be updated
    #
    # @return [Boolean] result of the operation
    def self.update(ticket_type_id, attributes)
      object = Boolean.new('success')
      post object, "api/ticketType/#{ticket_type_id}", :params => attributes

      object
    end

    protected

    def populate(response_body)
      extract_attributes_from(response_body, 'ticketType')
    end
  end
end
