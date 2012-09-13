require 'test_helper'

describe Amiando::Sync do
  before do
    HydraCache.prefix = 'Sync'
  end

  after do
    HydraCache.prefix = nil
  end

  describe 'find' do
    it 'gets the next synchronization events' do
      sync = Amiando::Sync.find(0)
      Amiando.run

      sync.result.must_be_instance_of Amiando::Sync
      sync.result.events.must_be_instance_of Array
      sync.result.next_id.must_be :>, 0

      sync_event = sync.result.events.first
      sync_event.must_be_instance_of Amiando::Sync::Event
    end
  end

  describe Amiando::Sync::Event do
    it 'simply converts the given attributes' do
      sync_event = Amiando::Sync::Event.new(:id => 1, :object_id => 12, :path => '/some/thing')

      sync_event.id.must_equal 1
      sync_event.object_id.must_equal 12
      sync_event.path.must_equal '/some/thing'
    end
  end
end
