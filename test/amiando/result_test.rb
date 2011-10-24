require 'test_helper'

describe Amiando::Result do
  it "raises error if you try to get the result before it's been calculated" do
    lambda { result = Amiando::Result.new{}; result.result }.must_raise Amiando::Error::NotInitialized
  end

  it "uses the passed block to calculate the result" do
    result = Amiando::Result.new do |something|
      something * 2
    end
    result.populate(2)
    result.result.must_equal 4
  end
end
