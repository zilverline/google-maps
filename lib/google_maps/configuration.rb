# frozen_string_literal: true

module Google
  module Maps
    # Defines constants and methods related to configuration
    module Configuration
      # An array of valid keys in the options hash when configuring an {Google::Maps::API}
      VALID_OPTIONS_KEYS = %i[
        end_point premier_key premier_client_id format
        directions_service places_service geocode_service
        api_key default_language place_details_service default_params
      ].freeze

      # By default, set "https://maps.googleapis.com/maps/api/" as the server
      DEFAULT_END_POINT = 'https://maps.googleapis.com/maps/api/'

      DEFAULT_DIRECTIONS_SERVICE = 'directions'
      DEFAULT_PLACES_SERVICE = 'place/autocomplete'
      DEFAULT_PLACE_DETAILS_SERVICE = 'place/details'
      DEFAULT_GEOCODE_SERVICE = 'geocode'

      DEFAULT_FORMAT = 'json'

      # premier API key to sign parameters
      DEFAULT_PREMIER_KEY = nil

      # premier client id
      DEFAULT_PREMIER_CLIENT_ID = nil

      # a api key
      DEFAULT_API_KEY = nil

      # default language
      DEFAULT_LANGUAGE = :en

      # params to send which each request configured per service
      # ie.: {places_service: {location: "52.0910,5.1220", radius: 300000}}
      DEFAULT_PARAMS = {}.freeze

      # @private
      attr_accessor(*VALID_OPTIONS_KEYS)

      # When this module is extended, set all configuration options to their default values
      def self.extended(base)
        base.reset
      end

      # Convenience method to allow configuration options to be set in a block
      def configure
        yield self
      end

      # Create a hash of options and their values
      def options
        VALID_OPTIONS_KEYS.inject({}) do |option, key|
          option.merge!(key => send(key))
        end
      end

      # Reset all configuration options to defaults
      def reset
        self.end_point = DEFAULT_END_POINT
        self.format = DEFAULT_FORMAT
        self.directions_service = DEFAULT_DIRECTIONS_SERVICE
        self.places_service = DEFAULT_PLACES_SERVICE
        self.place_details_service = DEFAULT_PLACE_DETAILS_SERVICE
        self.geocode_service = DEFAULT_GEOCODE_SERVICE
        self.premier_client_id = DEFAULT_PREMIER_CLIENT_ID
        self.premier_key = DEFAULT_PREMIER_KEY
        self.api_key = DEFAULT_API_KEY
        self.default_language = DEFAULT_LANGUAGE
        self.default_params = DEFAULT_PARAMS
        self
      end
    end
  end
end
