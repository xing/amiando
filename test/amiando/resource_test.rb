require 'test_helper'

describe Amiando::Resource do
  class Wadus < Amiando::Resource
    def self.create
      post new, 'somewhere'
    end
  end

  it 'raises error when amiando is down' do
    stub_request(:post, /somewhere/).to_return(:status => 503)
    lambda {
      key = Wadus.create
      Amiando.run
    }.must_raise Amiando::Error::ServiceDown
  end

  it 'raises an error if populate method is not implemented' do
    lambda {
      Wadus.new.populate
    }.must_raise Amiando::Error::NotImplemented
  end
end
