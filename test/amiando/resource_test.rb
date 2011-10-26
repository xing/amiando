require 'test_helper'

describe Amiando::Resource do
  class Wadus < Amiando::Resource
    map :first_name, :firstName
    map :last_name , :lastName
    map :creation, :creation, :type => :time

    def self.create
      object = new
      post object, 'somewhere', :populate_method => :populate_create
      object
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
      Wadus.new.populate(nil)
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
    Wadus.reverse_map_params('firstName' => '1', 'lastName' => '2', 'wadus' => '3').must_equal expected
  end

  it 'maps attributes with typecasting' do
    time      = Time.at(0).utc
    expected  = { :creation => '1970-01-01T00:00:00Z' }
    Wadus.map_params(:creation => time).must_equal expected
  end

  it 'automatically typecasts if the object is a Time' do
    time      = Time.at(0).utc
    expected  = { :firstName => '1970-01-01T00:00:00Z' }
    Wadus.map_params(:first_name => time).must_equal expected
  end

  it 'reverse maps attributes with typecasting' do
    time      = Time.at(0).utc
    expected  = { :creation => time }
    Wadus.reverse_map_params(:creation => '1970-01-01T00:00:00Z').must_equal expected
  end

  describe 'synchronous calls' do
    it 'accepts synchronous calls' do
      stub_request(:post, /somewhere/).to_return(:status => 200, :body => '{"success":true}')
      Wadus.sync_create.success.must_equal true
    end
  end

  describe 'autorun' do
    before do
      Amiando.autorun = true
      stub_request(:post, /somewhere/).to_return(:status => 200, :body => '{"success":true, "id": 1}')
    end

    after do
      Amiando.autorun = nil
    end

    let(:wadus) { Wadus.create }

    it 'should return the result when calling autorun' do
      wadus.id.must_equal 1
    end

    it 'should return the success' do
      wadus.success.must_equal true
    end

    it 'should return no errors' do
      wadus.errors.must_be_nil
    end

    it 'should return the request' do
      wadus.request.wont_be_nil
    end

    it 'should return the response' do
      wadus.response.wont_be_nil
    end
  end
end
