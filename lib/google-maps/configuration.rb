module Google
  module Maps
    # Defines constants and methods related to configuration
    module Configuration
      # An array of valid keys in the options hash when configuring an {Google::Maps::API}
      VALID_OPTIONS_KEYS = [:end_point, :premier_key, :premier_client_id, :format, :directions_service, :places_service, :geocode_service].freeze

      # By default, set "https://maps.googleapis.com/maps/api/" as the server
      DEFAULT_END_POINT = "https://maps.googleapis.com/maps/api/".freeze

      DEFAULT_DIRECTIONS_SERVICE = "directions".freeze
      DEFAULT_PLACES_SERVICE = "place/autocomplete".freeze
      DEFAULT_GEOCODE_SERVICE = "geocode".freeze

      DEFAULT_FORMAT = "json".freeze
      
      # premier API key to sign parameters
      DEFAULT_PREMIER_KEY = nil
      
      # premier client id
      DEFAULT_PREMIER_CLIENT_ID = nil
      
      # @private
      attr_accessor *VALID_OPTIONS_KEYS

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
        self.geocode_service = DEFAULT_GEOCODE_SERVICE
        self.premier_client_id = DEFAULT_PREMIER_CLIENT_ID
        self.premier_key = DEFAULT_PREMIER_KEY
        self
      end
    end
  end
end
