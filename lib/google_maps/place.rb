# frozen_string_literal: true

require File.expand_path('api', __dir__)

module Google
  module Maps
    class Place
      attr_reader :text, :html, :structured_text, :keyword, :place_id
      alias to_s text
      alias to_html html

      def initialize(data, keyword)
        @text = data.description
        @place_id = data.place_id
        @structured_text = {
          main: data.structured_formatting&.main_text,
          secondary: data.structured_formatting&.secondary_text
        }
        @html = highlight_keywords(data, keyword)
      end

      def self.find(keyword, language = :en)
        args = { language: language, input: keyword }
        API.query(:places_service, args).predictions.map { |prediction| Place.new(prediction, keyword) }
      end

      private

      def highlight_keywords(data, keyword)
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

      def place_id
        @data.place_id
      end

      def photos
        @data.photos
      end

      def url
        @data.url
      end

      def name
        @data.name
      end

      def website
        @data.website
      end

      def address
        @data.formatted_address
      end
      alias to_s address

      def address_components
        AddressComponentsProxy.new(@data.address_components)
      end

      def self.find(place_id, language = :en)
        args = { language: language, placeid: place_id }
        PlaceDetails.new(API.query(:place_details_service, args).result)
      end

      class AddressComponentsProxy
        def initialize(address_components)
          @address_components = address_components
        end

        def method_missing(method_name, *args)
          raise ArgumentError unless args.empty?

          @address_components.find do |component|
            component.types.first == method_name.to_s
          end
        end

        def respond_to_missing?(method_name, _include_private = false)
          @address_components.any? do |component|
            component.types.first == method_name.to_s
          end
        end
      end
    end
  end
end
