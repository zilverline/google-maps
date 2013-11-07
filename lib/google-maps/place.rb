require File.expand_path('../api', __FILE__)

module Google
  module Maps
    
    class Place
      attr_reader :text, :html, :keyword, :reference
      alias :to_s :text
      alias :to_html :html
      
      def initialize(data, keyword)
        @text = data.description
        @reference = data.reference
        @html = highligh_keywords(data, keyword)
      end
      
      def self.find(keyword, language=:en)
        args = {:language => language, :input =>  keyword }
        args.merge!(key: Google::Maps.api_key) unless Google::Maps.api_key.nil?

        API.query(:places_service, args).predictions.map{|prediction| Place.new(prediction, keyword) }
      end

      private

      def highligh_keywords(data, keyword)
        keyword = Regexp.escape(keyword)
        matches = Array(keyword.scan(/\w+/))
        html = data.description.dup
        matches.each do |match|
          html.gsub!(/(#{match})/i, '<strong>\1</strong>')
        end

        html
      end
    end

    class PlaceDetails
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def latitude
        @data.geometry.location.lat.to_s
      end

      def longitude
        @data.geometry.location.lng.to_s
      end

      def reference
        @data.reference
      end

      def address
        @data.formatted_address
      end
      alias :to_s :address

      def address_components
        AddressComponentsProxy.new(@data.address_components)
      end

      def self.find(reference, language=:en)
        args = {:language => language, :reference => reference}
        args.merge!(key: Google::Maps.api_key) unless Google::Maps.api_key.nil?

        PlaceDetails.new(API.query(:place_details_service, args).result)
      end

      class AddressComponentsProxy
        def initialize(address_components)
          @address_components = address_components
        end

        def method_missing(method, *args, &block)
          raise ArgumentError unless args.empty?

          @address_components.find do |component|
            component.types.first == method.to_s
          end
        end
      end
    end
  end
end
