require 'test_helper'

describe Amiando::Boolean do
  it "raises error if you try to get the result before it's been calculated" do
    lambda { Amiando::Boolean.new(:wadus).result }.must_raise Amiando::Error::NotInitialized
  end

  it "raises error if you try to get the result before it's been calculated" do
    lambda {
      boolean = Amiando::Boolean.new(:wadus)
      boolean.populate('not_wadus' => true)
    }.must_raise Amiando::Error::NotInitialized
  end

  it "uses the passed attribute to know its result on populate" do
    boolean = Amiando::Boolean.new(:wadus)
    boolean.populate('wadus' => false)

    boolean.result.must_equal false
  end

  it "sets the success value from the request" do
    boolean = Amiando::Boolean.new(:wadus)
    boolean.populate('wadus' => true, 'success' => false)

    boolean.success.must_equal false
  end
end
