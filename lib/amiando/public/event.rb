module Amiando
  module Public
    class Event < Resource
      map :selected_date,     :selectedDate,     :type => :time
      map :selected_end_date, :selectedEndDate,  :type => :time

      ##
      # Query the public api.
      #
      # @param [Hash] options
      #
      # Possible filter parameters are:
      # * start_date
      # * end_date
      # * language
      # * offset
      #
      # @return [Result] with a list of event ids (up to 100 per request)
      def self.search(options = {})
        object = Result.new do |response_body|
          response_body['ids']
        end
        get object, '/api/public/event/findPublic', :params => options
        object
      end

      ##
      # Query the public api. See the documentation [missing] for possible
      # filter parameters.
      #
      # @param id
      #
      # @return [Public::Event] with a list of event ids
      def self.find(id)
        object = new
        get object, "/api/public/event/#{id}"

        object
      end

      protected

      def populate(response_body)
        extract_attributes_from(response_body, 'event')
      end
    end
  end
end
