module Amiando

  ##
  # http://developers.amiando.com/index.php/REST_API_ApiKey
  class ApiKey < Resource

    ##
    # Creates an {ApiKey}.
    #
    # @param [Hash] possible attributes that can be set on creation.
    def self.create(attributes)
      raise ArgumentError.new('ApiKey name field is mandatory') unless attributes[:name]

      object  = new
      request = post object, '/api/apiKey/create', :params => attributes

      object
    end

    ##
    # Updates an {ApiKey}.
    #
    # @param [Hash] possible attributes that can be updated.
    def self.update(id, attributes)
      object  = Boolean.new(:success)
      request = post object, "/api/apiKey/#{id}", :params => attributes

      object
    end

    def populate(response_body)
      extract_attributes_from(response_body, 'apiKey')
    end
  end
end
