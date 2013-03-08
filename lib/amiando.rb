require "amiando/version"
require "typhoeus"
require "multi_json"
require "ostruct"
require "benchmark"

module Amiando
  autoload :Request,        'amiando/request'
  autoload :Resource,       'amiando/resource'
  autoload :Boolean,        'amiando/boolean'
  autoload :Result,         'amiando/result'
  autoload :Autorun,        'amiando/autorun'
  autoload :Utils,          'amiando/utils'
  autoload :Attributes,     'amiando/attributes'

  autoload :ApiKey,         'amiando/api_key'
  autoload :User,           'amiando/user'
  autoload :Partner,        'amiando/partner'
  autoload :Event,          'amiando/event'
  autoload :TicketCategory, 'amiando/ticket_category'
  autoload :TicketShop,     'amiando/ticket_shop'
  autoload :PaymentType,    'amiando/payment_type'
  autoload :TicketType,     'amiando/ticket_type'
  autoload :Sync,           'amiando/sync'

  module Public
    autoload :Event,        'amiando/public/event'
  end

  class Error < StandardError
    class ServiceDown    < Error; end
    class Timeout        < Error; end
    class ApiKeyNeeded   < Error; end
    class NotAuthorized  < Error; end
    class NotFound       < Error; end
    class NotImplemented < Error; end
    class NotInitialized < Error; end
    class MissingApiKey  < Error; end
  end

  class << self

    # Api key to be used at all times.
    attr_accessor :api_key

    # Logger instance. There's no logger by default.
    attr_accessor :logger

    attr_accessor :verbose

    # If set to true, will run the requests automatically when needed.
    attr_accessor :autorun

    # You can configure the amiando end point manually
    attr_writer   :base_url

    # Timeout value (in milliseconds). Default: 15 seconds.
    attr_accessor :timeout

    # Used for statistics (time-bandits for example)
    attr_accessor :total_time, :total_requests

    # Set default options for typhoeus
    attr_accessor :default_options

    URL       = 'https://www.amiando.com'
    TEST_URL  = 'https://test.amiando.com'

    # Connect to the production server
    def production!
      @production = true
    end

    # Connect to the test server (default)
    def development!
      @production = false
    end

    # @return [String] the url for the environment
    def base_url
      @base_url || (@production ? URL : TEST_URL)
    end

    def requests
      @requests ||= []
    end

    # Runs all queued requests
    def run
      exception = nil
      requests.each { |request| hydra.queue(request) }
      @total_requests += requests.size

      duration = Benchmark.realtime do
        begin
          hydra.run
        rescue Exception => exception
        end
      end
      @total_time += duration

      raise exception if exception
    ensure
      @requests = []
    end

    ##
    # Allows to switch temporarily the API key
    #
    # @param [String] api API key
    # @param [Block] block block to execute with the given key
    # @return  the result of the block
    def with_key(key)
      old_key = Amiando.api_key
      Amiando.api_key = key
      yield
    ensure
      Amiando.api_key = old_key
    end

    private

    def hydra
      @hydra ||= Typhoeus::Hydra.new
    end

  end

  ##
  # Default timeout of 15 seconds
  self.timeout = 15000

  self.total_time     = 0.0
  self.total_requests = 0
end
