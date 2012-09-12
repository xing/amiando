module Amiando
  module Attributes
    def self.included(base)
      base.class_eval do
        attr_reader :attributes
        extend ClassMethods
      end
    end

    module ClassMethods
      def map(local, remote, options = {})
        mapping[local] = remote
        typecasting[local] = options[:type] if options[:type]
      end

      def typecasting
        @typecasting ||= {}
      end

      def mapping
        @mapping ||= {}
      end

      ##
      # From { :first_name => '1', :last_name  => '2' }
      # to   { :firstName  => '1', :lastName   => '2' }
      def map_params(attributes)
        mapped_attributes = attributes.map do |key,value|
          mapped_key = mapping[key] || Utils.camelize(key, :lower).to_sym
          value = typecast(key, value)
          [mapped_key, value]
        end
        Hash[mapped_attributes]
      end

      def reverse_map_params(attributes)
        inverted_mapping = mapping.invert
        mapped_attributes = attributes.map do |key,value|
          key        = key.to_sym
          mapped_key = inverted_mapping[key] || Utils.underscore(key).to_sym
          value      = inverse_typecast(mapped_key, value)
          [mapped_key, value]
        end
        Hash[mapped_attributes]
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

    def id
      attributes[:id]
    end

    def type
      attributes[:type]
    end

    def [](key)
      @attributes[key.to_sym]
    end

    def respond_to?(method_name, include_private = false)
      super || attributes.key?(method_name)
    end

    def method_missing(method_name, *args, &block)
      if attributes.key?(method_name) && args.empty?
        attributes[method_name]
      else
        super
      end
    end

    protected

    def set_attributes(attributes)
      if attributes
        @attributes = {}

        self.class.reverse_map_params(attributes).each do |k,v|
          @attributes[k.to_sym] = v
        end
      end
    end
  end
end
