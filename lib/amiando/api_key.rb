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
      request = post object, '/api/apiKey/create', attributes

      object
    end

    ##
    # Updates an {ApiKey}.
    #
    # @param [Hash] possible attributes that can be updated.
    def self.update(id, attributes)
      object  = new
      request = post object, "/api/apiKey/#{id}", attributes

      object
    end

    def populate(response_body)
      @attributes = {}
      if response_body['apiKey']
        response_body['apiKey'].each do |key,val|
          @attributes[key.to_sym] = val
        end
      end

      @success = response_body['success']
    end
  end
end
