require 'test_helper'
require 'mocha'

describe "Using options" do 

  it "should send any options to the request" do
    Amiando.default_options = { :ignore_ssl => true }
    
    Amiando::Request.expects(:new).with do |object, verb, path, params, options |
      options[:ignore_ssl] == true
    end.returns(stub_everything)
    
    Amiando::Public::Event.search(:start_date => Time.utc(2012, 6, 18))
  end
  
end