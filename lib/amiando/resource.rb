module Amiando
  class Resource
    include Autorun
    include Attributes

    attr_accessor :request, :response
    attr_reader :success

    autorun :request, :response, :success, :attributes

    class << self
      def method_missing(method_name, *args, &block)
        if match = /sync_(.*)/.match(method_name.to_s)
          res = self.send(match[1], *args, &block)
          Amiando.run
          res
        else
          super
        end
      end

      private

      def do_request(object, verb, path, options = {})
        req = Request.new(object, verb, path, map_params(options[:params] || {}))
        object.request = req

        req.log_request

        req.on_complete do |response|
          req.log_response

          if response.timed_out?
            raise Error::Timeout
          end

          # Raise different errors depending on the return codes
          case response.code
          when 403
            raise Error::NotAuthorized.new(response.body)
          when 404
            raise Error::NotFound.new(response.body)
          when 503
            raise Error::ServiceDown.new(response.body)
          when 0
            raise Error.new(response.body)
          end

          parsed_body = MultiJson.decode(response.body)

          if parsed_body['errors'] && parsed_body['errors'].include?('com.amiando.api.rest.MissingParam.apikey')
            raise Error::MissingApiKey.new('This call requires an apikey')
          end

          object.response = response
          object.send(options[:populate_method] || :populate, parsed_body)
        end

        Amiando.requests << req
      end

      def get(object, path, options = {})
        do_request(object, :get, path, options)
      end

      def post(object, path, options = {})
        do_request(object, :post, path, options)
      end
    end

    def initialize(attributes = nil)
      set_attributes(attributes)
    end

    def populate(reponse_body)
      raise Error::NotImplemented.new("populate method not implemented for #{self.class}")
    end

    def populate_create(response_body)
      @attributes = {:id => response_body['id'], :errors => response_body['errors']}
      @success    = response_body['success']
    end

    def extract_attributes_from(response_body, key)
      @attributes = {}

      set_attributes(response_body[key])

      @success = response_body['success']
    end

    def ==(resource)
      id == resource.id
    end
  end
end
