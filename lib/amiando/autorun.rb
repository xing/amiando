module Amiando
  module Autorun
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def autorun(*fields)
        fields.each do |field|
          class_eval <<-EOS, __FILE__, __LINE__
            def #{field}
              Amiando.run if Amiando.autorun && !defined?(@#{field})
              if defined?(@#{field})
                @#{field}
              else
                raise Error::NotInitialized.new('Called result before the query was run')
              end
            end
          EOS
        end
      end
    end
  end
end
