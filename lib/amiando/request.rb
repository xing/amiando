module Amiando
  class Request < Typhoeus::Request
    attr_reader :object

    def initialize(object, verb, path, params = {})
      @object = object
      super(build_url(path), :method => verb, :params => params, :verbose => 1)
    end

    private

    def build_url(url)
      url = URI.join(::Amiando.base_url, url).to_s
      url = "#{url}?format=json&version=1"
      url = "#{url}&apikey=#{Amiando.api_key}" if Amiando.api_key
      url
    end
  end
end
