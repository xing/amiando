module Amiando
  def self.Factory(name, options = {})
    Factory.build(name, options)
  end

  module Factory
    extend self

    def build(name, options)
      case name
      when :api_key
        Amiando::ApiKey.create({:name => 'wadus'}.merge(options))
      when :user
        Amiando::User.create({
          :first_name => 'Jorge',
          :last_name  => 'Llop',
          :password   => '123456',
          :language   => 'es'
        }.merge(options))
      end
    end

    def create(name, options)
      object = build(name, options)
      Amiando.run
      object
    end
  end
end
