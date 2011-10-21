require 'test_helper'

describe Amiando::Resource do
  class Wadus < Amiando::Resource
    self.mapping = {
      :first_name => :firstName,
      :last_name  => :lastName
    }

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

  it "raises an error when the call doesnt supply the required api key" do
    stub_request(:post, /somewhere/).to_return(
      :status => 400,
      :body => "{\"errors\":[\"com.amiando.api.rest.MissingParam.apikey\"],\"success\":false}"
    )

    lambda {
      Wadus.create
      Amiando.run
    }.must_raise Amiando::Error::MissingApiKey
  end

  it 'maps attributes appropriately' do
    expected = {:firstName => '1', :lastName => '2', :wadus => '3'}
    Wadus.map_params(:first_name => '1', :last_name => '2', :wadus => '3').must_equal expected
  end

  it 'reverse maps attributes appropriately' do
    expected = {:first_name => '1', :last_name => '2', :wadus => '3'}
    Wadus.reverse_map_params(:firstName => '1', :lastName => '2', :wadus => '3').must_equal expected
  end
end
