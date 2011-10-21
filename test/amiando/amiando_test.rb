require 'test_helper'

describe Amiando do
  it 'should return the right url for the test environment' do
    Amiando.base_url.must_equal 'https://test.amiando.com'
  end

  it 'should return the right url for the production environment' do
    Amiando.production!
    Amiando.base_url.must_equal 'https://amiando.com'
    Amiando.development!
  end
end
