module Google
  module Maps
    # Defines constants and methods related to configuration
    module Configuration
      # An array of valid keys in the options hash when configuring an {Google::Maps::API}
      VALID_OPTIONS_KEYS = [:end_point, :api_key].freeze

      # By default, set "http://maps.googleapis.com/maps/api/json/" as the server
      DEFAULT_END_POINT = "http://maps.googleapis.com/maps/api/directions/json".freeze
      
      # API key to connect to Google
      DEFAULT_API_KEY = nil
      
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
        self.api_key = DEFAULT_API_KEY
        self
      end
    end
  end
end
