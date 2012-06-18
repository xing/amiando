require 'test_helper'

describe Amiando::Public::Event do
  before do
    HydraCache.prefix = 'Public::Event'
  end

  after do
    HydraCache.prefix = nil
  end

  it 'filters by start date' do
    date = Time.parse("2012-06-18")

    events = Amiando::Public::Event.search(:start_date => date)

    Amiando.run
    id = events.result.first

    event = Amiando::Public::Event.find(id)
    Amiando.run

    event.id.must_equal id
    event.selected_date.must_be :>=, date
  end
end
