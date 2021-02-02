# frozen_string_literal: true

require File.expand_path('google_maps/configuration', __dir__)
require File.expand_path('google_maps/logger', __dir__)
require File.expand_path('google_maps/route', __dir__)
require File.expand_path('google_maps/place', __dir__)
require File.expand_path('google_maps/location', __dir__)
require File.expand_path('google_maps/distance_matrix', __dir__)

module Google
  module Maps
    extend Configuration
    extend Logger

    def self.route(from, to, options = {})
      Route.new(from, to, options_with_defaults(options))
    end

    def self.distance(from, to, options = {})
      Route.new(from, to, options_with_defaults(options)).distance.text
    end

    def self.duration(from, to, options = {})
      Route.new(from, to, options_with_defaults(options)).duration.text
    end

    def self.places(keyword, language = default_language)
      Place.find(keyword, language)
    end

    def self.place(place_id, language = default_language)
      PlaceDetails.find(place_id, language)
    end

    def self.distance_matrix(from, to, options = {})
      DistanceMatrix.new(from, to, options_with_defaults(options))
    end

    def self.geocode(address, language = default_language)
      Location.find(address, language)
    rescue ZeroResultsException
      []
    end

    class << self
      protected

      def options_with_defaults(options)
        { language: default_language }.merge(options)
      end
    end
  end
end
