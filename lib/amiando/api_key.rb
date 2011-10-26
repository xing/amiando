module Amiando

  ##
  # http://developers.amiando.com/index.php/REST_API_ApiKey
  class ApiKey < Resource

    ##
    # Creates an {ApiKey}.
    #
    # @param [Hash] attributes possible attributes that can be set on creation.
    #
    # @raise [ArgumentError] if no name provided in attributes
    # @return [ApiKey]
    def self.create(attributes)
      raise ArgumentError.new('ApiKey name field is mandatory') unless attributes[:name]

      object = new
      post object, '/api/apiKey/create', :params => attributes

      object
    end

    ##
    # Updates an {ApiKey}.
    #
    # @param [Hash] attributes possible attributes that can be updated.
    # @return [Boolean]  the result value
    def self.update(id, attributes)
      object = Boolean.new(:success)
      post object, "/api/apiKey/#{id}", :params => attributes

      object
    end

    protected

    def populate(response_body)
      extract_attributes_from(response_body, 'apiKey')
    end
  end
end
