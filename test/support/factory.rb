module Amiando
  def self.Factory(name, options = {})
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
end
