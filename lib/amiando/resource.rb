module Amiando
  class Resource
    attr_accessor :request, :response
    attr_reader :success

    class << self
      def post(object, path, params = {})
        req = Request.new(object, :post, path, params)
        object.request = req

        req.on_complete do |response|

          # Raise different errors depending on the return codes
          case response.code
          when 503
            raise Error::ServiceDown.new(response.body)
          when 403
            raise Error::NotAuthorized.new(response.body)
          when 404
            raise Error::NotFound.new(response.body)
          end

          parsed_body = Yajl::Parser.parse(response.body)

          object.response = response
          object.populate(parsed_body)
        end

        Amiando.requests << req
      end
    end

    def [](key)
      @attributes[key.to_sym]
    end

    def method_missing(method_name, *args, &block)
      if @attributes.key?(method_name) && args.empty?
        @attributes[method_name]
      else
        super
      end
    end

    def id
      @attributes[:id]
    end

    def populate
      raise Error::NotImplemented.new("populate method not implemented for #{self.class}")
    end
  end
end
