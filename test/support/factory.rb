module Amiando
  def self.Factory(name, options = {})
    Factory.build(name, options)
  end

  module Factory
    extend self

    def build(name, options = {})
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
      when :event
        Amiando::Event.create({
          :host_id       => Amiando::TEST_USER.id,
          :title         => 'Secret title',
          :country       => 'es',
          :selected_date => Time.at(0)
        }.merge(options))
      when :ticket_category
        Amiando::TicketCategory.create(
          Amiando::Factory.create(:event).id, {
          :name      => "Name",
          :price     => "50",
          :available => "1"
        }.merge(options))
      end
    end

    def create(name, options = {})
      object = build(name, options)
      Amiando.run
      object
    end
  end
end
