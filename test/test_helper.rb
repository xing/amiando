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

Amiando.hydra.cache_setter &HydraCache.method(:setter)
Amiando.hydra.cache_getter &HydraCache.method(:getter)

WebMock.allow_net_connect!
