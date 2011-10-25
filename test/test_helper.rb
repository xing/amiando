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

HydraCache.prefix = 'Global'

module Amiando
  TEST_KEY = Amiando::Factory.create(:api_key, :name => 'test key').key

  TEST_USER = Amiando.with_key(TEST_KEY) do
    Amiando::Factory.create(:user, :username => "jorgellop-base-#{HydraCache.revision}@example.com")
  end
end

HydraCache.prefix = nil
