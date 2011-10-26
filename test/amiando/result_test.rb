require 'test_helper'

describe Amiando::Result do
  it "raises error if you try to get the result before it's been calculated" do
    lambda { result = Amiando::Result.new{}; result.result }.must_raise Amiando::Error::NotInitialized
  end

  it "uses the passed block to calculate the result" do
    result = Amiando::Result.new do |something|
      something[:val] * 2
    end
    result.populate(:val => 2)
    result.result.must_equal 4
  end

  it "can access itself in the block" do
    result = Amiando::Result.new do |something, res|
      res.errors = ["hi"]
      something[:val] * 2
    end
    result.populate(:val => 2)
    result.result.must_equal 4
    result.errors.must_equal ["hi"]
  end

  it "initializes success to whatever comes in the populate" do
    result = Amiando::Result.new do |something|
      something[:val] * 2
    end

    result.populate(:val => 2, 'success' => true)
    result.success.must_equal true
  end

  it "will initialize the return value to the 'success' key by default" do
    result = Amiando::Result.new

    result.populate('success' => false)
    result.result.must_equal false
    result.success.must_equal false
  end
end
