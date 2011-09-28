require File.expand_path('../api', __FILE__)

module Google
  module Maps
    
    class Route
      attr_accessor :from, :to
      
      def initialize(from, to)
        @from, @to = from, to
      end
      
      def distance
        route.legs.first.distance
      end
      
      def duration
        route.legs.first.duration
      end
      
      private
      def route
        # default to the first returned route (the most efficient one)
        @response ||= API.query(:origin => from, :destination => to).first
      end
    end
    
  end
end