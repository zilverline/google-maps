require File.expand_path('../api', __FILE__)

module Google
  module Maps
    class Location
      attr_reader :address, :latitude, :longitude
      alias :to_s :address

      def initialize(address, latitude, longitude)
        @address = address
        @latitude = latitude
        @longitude = longitude
      end

      def lat_lng
        [latitude, longitude]
      end

      def self.find(address, language=:en)
        args = { language: language, address: address }
        args[:key] = Google::Maps.api_key unless Google::Maps.api_key.nil?

        API.query(:geocode_service, args).results.map do |result|
          Location.new(
            result.formatted_address,
            result.geometry.location.lat,
            result.geometry.location.lng,
          )
        end
      end
    end

  end
end
