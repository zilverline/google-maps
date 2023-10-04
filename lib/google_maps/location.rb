# frozen_string_literal: true

require File.expand_path('api', __dir__)

module Google
  module Maps
    class Location
      attr_reader :address, :latitude, :longitude, :place_id, :components
      alias to_s address

      def initialize(address, latitude, longitude, place_id, components = {})
        @address = address
        @latitude = latitude
        @longitude = longitude
        @place_id = place_id
        @components = components
      end

      def lat_lng
        [latitude, longitude]
      end

      def self.find(address, language = :en)
        args = { language: language, address: address }

        API.query(:geocode_service, args).results.map do |result|
          Location.new(
            result.formatted_address,
            result.geometry.location.lat,
            result.geometry.location.lng,
            result.place_id,
            format_components(result.address_components)
          )
        end
      end

      def self.format_components(address_components)
        address_components.each_with_object({}) do |v, acc|
          types = v['types']
          types.each do |t|
            acc[t] ||= []
            acc[t] << v['long_name']
          end
        end
      end
    end
  end
end
