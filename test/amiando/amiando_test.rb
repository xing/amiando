require 'test_helper'

describe Amiando do
  it 'should return the right url for the test environment' do
    Amiando.base_url.must_equal 'https://test.amiando.com'
  end

  it 'should return the right url for the production environment' do
    Amiando.production!
    Amiando.base_url.must_equal 'https://www.amiando.com'
    Amiando.development!
  end

  it 'should allow a configurable url' do
    Amiando.base_url = 'https://something.amiando.com'
    Amiando.base_url.must_equal 'https://something.amiando.com'
    Amiando.base_url = nil
  end

  describe 'logger' do
    it 'should define a logger' do
      log = StringIO.new
      Amiando.logger = Logger.new(log)
      Amiando.logger.debug 'hi'

      log.string.must_match(/hi/)
      Amiando.logger = nil
    end
  end
end
