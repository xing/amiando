require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'webmock/minitest'
require 'amiando'

begin
  require 'ruby-debug'
rescue LoadError; end

begin
  require 'minitest/reporters'
  MiniTest::Unit.runner = MiniTest::SuiteRunner.new
  MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new
rescue LoadError; end

require 'hydra_cache'
require 'support/factory'
require 'support/hydra_monkey_patch'

Amiando.send(:hydra).cache_setter &HydraCache.method(:setter)
Amiando.send(:hydra).cache_getter &HydraCache.method(:getter)
HydraCache.revision = 5
HydraCache.prefix = 'Global'
HydraCache.fixtures_path = 'test/fixtures'

WebMock.allow_net_connect!
Amiando.verbose = true


module Amiando
  self.api_key = TEST_KEY = Amiando::Factory.create(:api_key, :name => 'test key').key

  TEST_USER = Amiando::Factory.create(:user, :username => "jorgellop-base-#{HydraCache.revision}@example.com")

  def self.reset_requests
    @requests = []
  end
end

HydraCache.prefix = nil
