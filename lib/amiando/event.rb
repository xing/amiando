module Amiando

  ##
  # http://developers.amiando.com/index.php/REST_API_Events
  class Event < Resource
    map :host_id,                  :hostId
    map :selected_date,            :selectedDate,     :type => :time
    map :selected_end_date,        :selectedEndDate,  :type => :time
    map :short_description,        :shortDescription
    map :event_type,               :eventType
    map :organisator_display_name, :organisatorDisplayName
    map :partner_event_url,        :partnerEventUrl
    map :publish_search_engines,   :publishSearchEngines
    map :search_engine_tags,       :searchEngineTags
    map :location_description,     :locationDescription
    map :zip_code,                 :zipCode
    map :creation_time,            :creationTime,     :type => :time
    map :last_modified,            :lastModified,     :type => :time

    ##
    # Creates an event.
    #
    # @return [Event] will not return the full event and only the id attribute
    #   will be available.
    def self.create(attributes)
      object  = new
      request = post object, '/api/event/create',
        :params          => map_params(attributes),
        :populate_method => :populate_create

      object
    end

    ##
    # Updates an event.
    #
    # @return [Boolean] if it was successful or not.
    def self.update(id, attributes)
      object = Result.new do |response_body, result|
        unless response_body['success']
          result.errors = response_body['errors']
        end
        response_body['success']
      end
      request = post object, "/api/event/#{id}", :params => map_params(attributes)

      object
    end

    ##
    # Fetch an event
    def self.find(id)
      object  = new
      request = get object, "/api/event/#{id}"

      object
    end

    ##
    # See if an event id exists
    def self.exists?(identifier)
      object  = Boolean.new('exists')
      request = get object, "api/event/exists",
        :params => { :identifier => identifier }

      object
    end

    ##
    # Deletes an event
    #
    # @param [Integer] event id
    #
    # @return [Boolean] with the result of the operation
    def self.delete(id)
      object = Boolean.new('deleted')
      request = do_request object, :delete, "/api/event/#{id}"

      object
    end

    ##
    # Activate an event
    #
    # @param [Integer] the event id
    #
    # @return [Result] if it was activated or not.
    def self.activate(id)
      object = Result.new do |response_body, result|
        unless response_body['success']
          result.errors = response_body['errors']
        end
        response_body['success']
      end
      request = post object, "/api/event/#{id}/activate"

      object
    end

    ##
    # Search by identifier or title.
    #
    # @param [Hash] a hash with 1 entry, either :identifier or :title
    #
    # @return [Result] with an array of ids
    def self.search(by)
      unless by[:identifier].nil? ^ by[:title].nil? # XOR
        raise ArgumentError.new('Events can be searched either by identifier or by title, include only one.')
      end

      object  = Result.new { |response_body| response_body['ids'] }
      request = get object, '/api/event/find', :params => by

      object
    end

    private

    def populate(response_body)
      extract_attributes_from(response_body, 'event')
    end

    def populate_create(response_body)
      @attributes = {:id => response_body['id']}
      @success    = response_body['success']
    end
  end
end
