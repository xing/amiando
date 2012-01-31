module Amiando

  ##
  # http://developers.amiando.com/index.php/REST_API_Partner
  class Partner < Resource
    ##
    # Creates a partner.
    #
    # @param [Hash] attributes
    #
    # @return [Partner] but will only have the id loaded
    def self.create(attributes)
      object = new
      post object, '/api/partner/create',
        :params          => attributes,
        :populate_method => :populate_create

      object
    end

    ##
    # Updates the partner.
    #
    # @param id the internal id of the partner to update.
    # @param [Hash] attributes
    #
    # @return [Result] saying if the update was successful
    def self.update(id, attributes)
      object = Result.new
      post object, "/api/partner/#{id}", :params => attributes

      object
    end

    ##
    # Find a partner
    #
    # @param id id of the partner
    #
    # @return [Partner] the partner with that id
    def self.find(id)
      object = new
      get object, "/api/partner/#{id}"

      object
    end

    private

    def populate(response_body)
      extract_attributes_from(response_body, 'partner')
    end
  end
end
