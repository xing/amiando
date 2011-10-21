module Amiando

  ##
  # This object is intended to be used when an api will return a boolean
  # response, but due to the delayed nature of doing requests in parallel,
  # can't be initialized from the beginning.
  #
  # After the object is populated, you can ask the result with the result
  # method.
  class Boolean
    attr_accessor :request, :response

    def initialize(response_attribute)
      @response_attribute = response_attribute.to_s
    end

    def populate(response_body)
      if response_body.key?(@response_attribute)
        @result = response_body[@response_attribute]
      else
        raise Error::NotInitialized.new("The response doesn't have the expected attribute")
      end
    end

    def result
      if defined?(@result)
        @result
      else
        raise Error::NotInitialized.new('Called result before the query was run')
      end
    end
  end
end
