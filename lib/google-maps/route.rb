require File.expand_path('../api', __FILE__)

module Google
  module Maps
    
    class Route
      attr_accessor :from, :to, :language
      
      def initialize(from, to, language=:en)
        @from, @to, @language = from, to, language
      end

      def method_missing(name, *args, &block)
        if route.legs.first.key?(name)
          route.legs.first.send(name)
        else
          super
        end
      end
      
      def origin_latlong
        "#{self.start_location.lat},#{self.start_location.lng}"
      end
      
      def destination_latlong
        "#{self.end_location.lat},#{self.end_location.lng}"
      end
      
      private
      def route
        # default to the first returned route (the most efficient one)
        @response ||= API.query(:origin => from, :destination => to, :language => language).first
      end
    end
    
  end
end