# frozen_string_literal: true

require File.expand_path('api', __dir__)

module Google
  module Maps
    class DistanceMatrix
      attr_accessor :from, :to, :options

      def initialize(from, to, options = {})
        options = { language: options } unless options.is_a? Hash
        @from = from
        @to = to
        @options = { language: :en }.merge(options)
      end

      def distance
        element.distance.value
      end

      def duration
        element.duration.value
      end

      private

      def element
        element = distance_matrix.rows.first.elements.first

        raise Google::Maps::ZeroResultsException if (element.status == 'NOT_FOUND' || element.status == 'ZERO_RESULTS')

        element
      end

      def distance_matrix
        @distance_matrix ||= API.query(:distance_matrix_service, @options.merge(origins: from, destinations: to))
      end
    end
  end
end
