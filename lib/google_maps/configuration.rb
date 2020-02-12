# frozen_string_literal: true

module Google
  module Maps
    class InvalidConfigurationError < StandardError; end
    # Defines constants and methods related to configuration
    module Configuration
      # An array of valid keys in the options hash when configuring an {Google::Maps::API}
      VALID_OPTIONS_KEYS = %i[
        end_point authentication_mode client_id client_secret format
        directions_service places_service geocode_service distance_matrix_service
        api_key default_language place_details_service default_params
      ].freeze

      API_KEY = 'api_key'
      DIGITAL_SIGNATURE = 'digital_signature'

      # By default, set "https://maps.googleapis.com/maps/api/" as the server
      DEFAULT_END_POINT = 'https://maps.googleapis.com/maps/api/'

      DEFAULT_DIRECTIONS_SERVICE = 'directions'
      DEFAULT_PLACES_SERVICE = 'place/autocomplete'
      DEFAULT_PLACE_DETAILS_SERVICE = 'place/details'
      DEFAULT_GEOCODE_SERVICE = 'geocode'
      DEFAULT_DISTANCE_MATRIX_SERVICE = 'distancematrix'

      DEFAULT_FORMAT = 'json'

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
        validate_config
      end

      def validate_config
        return validate_api_key if authentication_mode == API_KEY
        return validate_digital_signature if authentication_mode == DIGITAL_SIGNATURE

        raise Google::Maps::InvalidConfigurationError, 'No valid authentication mode provided'
      end

      def validate_api_key
        raise Google::Maps::InvalidConfigurationError, 'No API key provided' unless api_key
      end

      def validate_digital_signature
        raise Google::Maps::InvalidConfigurationError, 'No client id provided' unless client_id
        raise Google::Maps::InvalidConfigurationError, 'No client secret provided' unless client_secret
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
        self.distance_matrix_service = DEFAULT_DISTANCE_MATRIX_SERVICE
        self.default_language = DEFAULT_LANGUAGE
        self.default_params = DEFAULT_PARAMS
        self.authentication_mode = nil
        self.api_key = nil
        self.client_id = nil
        self.client_secret = nil
        self
      end
    end
  end
end
