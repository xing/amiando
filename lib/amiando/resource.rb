module Amiando
  class Resource
    attr_accessor :request, :response
    attr_reader :success

    class << self
      def map(local, remote, options = {})
        mapping[local] = remote
        typecasting[local] = options[:type] if options[:type]
      end

      def typecasting
        @@typecasting ||= {}
      end

      def mapping
        @@mapping ||= {}
      end

      ##
      # From { :first_name => '1', :last_name  => '2' }
      # to   { :firstName  => '1', :lastName   => '2' }
      def map_params(attributes)
        mapped_attributes = attributes.map do |key,value|
          mapped_key = mapping[key] || key
          value = typecast(key, value)
          [mapped_key, value]
        end
        Hash[mapped_attributes]
      end

      def reverse_map_params(attributes)
        inverted_mapping = mapping.invert
        mapped_attributes = attributes.map do |key,value|
          mapped_key = inverted_mapping[key] || key
          value = inverse_typecast(key, value)
          [mapped_key, value]
        end
        Hash[mapped_attributes]
      end

      private

      def do_request(object, verb, path, options = {})
        req = Request.new(object, verb, path, options[:params] || {})
        object.request = req

        req.on_complete do |response|

          # Raise different errors depending on the return codes
          case response.code
          when 403
            raise Error::NotAuthorized.new(response.body)
          when 404
            raise Error::NotFound.new(response.body)
          when 503
            raise Error::ServiceDown.new(response.body)
          end

          parsed_body = Yajl::Parser.parse(response.body)

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

      def typecast(key, value)
        if typecasting[key] == :time || value.is_a?(Time)
          value.iso8601
        else
          value
        end
      end

      def inverse_typecast(key, value)
        if typecasting[key] == :time
          Time.parse(value)
        else
          value
        end
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

    def populate(reponse_body = {})
      raise Error::NotImplemented.new("populate method not implemented for #{self.class}")
    end

    def extract_attributes_from(response_body, key)
      @attributes = {}
      if response_body[key]
        self.class.reverse_map_params(response_body[key]).each do |k,v|
          @attributes[k.to_sym] = v
        end
      end

      @success = response_body['success']
    end
  end
end
