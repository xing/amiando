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

    def log_response
      if Amiando.logger
        filtered_url = url.gsub(/password=([^&]+)/, "password=[FILTERED]")
        Amiando.logger.info "REST request #{filtered_url} returned #{response.code} and took #{response.time} seconds"

        if Amiando.logger.debug? && response.body
          filtered_body = response.body.inspect.gsub(/password: .*/,'password: [FILTERED]')
          Amiando.logger.debug "REST request body: #{filtered_body}"
        end
      end
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
