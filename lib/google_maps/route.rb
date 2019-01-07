# frozen_string_literal: true

require File.expand_path('api', __dir__)

module Google
  module Maps
    class Route
      attr_accessor :from, :to, :options

      def initialize(from, to, options = {})
        options = { language: options } unless options.is_a? Hash
        @from = from
        @to = to
        @options = { language: :en }.merge(options)
      end

      def method_missing(method_name, *args, &block)
        if route.legs.first.key?(method_name)
          route.legs.first.send(method_name)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        route.legs.first.key?(method_name) || super
      end

      def origin_latlong
        "#{start_location.lat},#{start_location.lng}"
      end

      def destination_latlong
        "#{end_location.lat},#{end_location.lng}"
      end

      private

      def route
        # default to the first returned route (the most efficient one)
        @route ||= API.query(:directions_service, @options.merge(origin: from, destination: to)).routes.first
      end
    end
  end
end
