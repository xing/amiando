require "amiando/version"
require "typhoeus"
require "json"

module Amiando
  autoload :Request,        'amiando/request'
  autoload :Resource,       'amiando/resource'
  autoload :Boolean,        'amiando/boolean'
  autoload :Result,         'amiando/result'
  autoload :Autorun,        'amiando/autorun'

  autoload :ApiKey,         'amiando/api_key'
  autoload :User,           'amiando/user'
  autoload :Partner,        'amiando/partner'
  autoload :Event,          'amiando/event'
  autoload :TicketCategory, 'amiando/ticket_category'
  autoload :TicketShop,     'amiando/ticket_shop'
  autoload :PaymentType,    'amiando/payment_type'

  module Error
    class ServiceDown    < Exception; end
    class ApiKeyNeeded   < Exception; end
    class NotAuthorized  < Exception; end
    class NotFound       < Exception; end
    class NotImplemented < Exception; end
    class NotInitialized < Exception; end
    class MissingApiKey  < Exception; end
  end

  class << self
    attr_accessor :api_key
    attr_accessor :logger
    attr_accessor :verbose
    attr_accessor :autorun

    URL       = 'https://amiando.com'
    TEST_URL  = 'https://test.amiando.com'

    def production!
      @production = true
    end

    def development!
      @production = false
    end

    def base_url
      @production ? URL : TEST_URL
    end

    def requests
      @requests ||= []
    end

    def run
      requests.each{ |request| hydra.queue(request) }
      hydra.run
    ensure
      @requests = []
    end

    def hydra
      @hydra ||= Typhoeus::Hydra.new
    end

    def with_key(key)
      old_key = Amiando.api_key
      Amiando.api_key = key
      yield
    ensure
      Amiando.api_key = old_key
    end
  end
end
