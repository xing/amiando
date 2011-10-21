require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'webmock/minitest'
require 'amiando'
begin
  require 'ruby-debug'
rescue LoadError
end

require 'support/hydra_cache'
require 'support/factory'

Amiando.hydra.cache_setter &HydraCache.method(:setter)
Amiando.hydra.cache_getter &HydraCache.method(:getter)
HydraCache.revision = 1

WebMock.allow_net_connect!

module Amiando
  TEST_KEY = begin
              key = Amiando::Factory(:api_key, :name => 'test key')
              Amiando.run
              key.key
            end
end
