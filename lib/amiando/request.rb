module Amiando
  class Request < Typhoeus::Request
    attr_reader :object

    def initialize(object, verb, path, params)
      @object = object

      if verb == :post
        path = build_url(path, default_params)
      else
        path = build_url(path)
        params = default_params.merge(params || {})
      end

      super(path, :method => verb, :params => params, :verbose => Amiando.verbose)
    end

    def log_request
      if Amiando.logger && Amiando.logger.debug?
        Amiando.logger.debug "REST request #{filter_log(url)} with body #{filter_log(self.params.inspect)}"
      end
    end

    def log_response
      if Amiando.logger
        Amiando.logger.info "REST request #{filter_log(url)} returned #{response.code} and took #{response.time} seconds"
        if Amiando.logger.debug? && response.body
          Amiando.logger.debug "REST response body: #{filter_log(response.body.inspect)}"
        end
      end
    end

    def filter_log(text)
      text.gsub(/password=([^&]+)/, "password=[FILTERED]").gsub(/password: .*/,'password: [FILTERED]')
    end

    private

    def default_params
      default = {
        :format  => :json,
        :version => 1
      }
      default.merge!(:apikey => Amiando.api_key) if Amiando.api_key
      default
    end

    def build_url(url, merge_params = {})
      url = URI.join(Amiando.base_url, url).to_s
      unless merge_params.empty?
        query_params = merge_params.map{|k,v| "#{k}=#{v}"}.join('&')
        url = "#{url}?#{query_params}"
      end
      url
    end
  end
end
