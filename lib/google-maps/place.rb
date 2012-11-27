require File.expand_path('../api', __FILE__)

module Google
  module Maps
    
    class Place
      attr_reader :text, :html, :keyword, :reference
      alias :to_s :text
      alias :to_html :html
      
      def initialize(data, keyword)
        @text = data.description
        @reference = data.reference
        @html = data.description.gsub(/(#{keyword})/i, '<strong>\1</strong>')
      end
      
      def self.find(keyword, language=:en)
        args = {:language => language, :input => keyword}
        args.merge!(key: Google::Maps.api_key) unless Google::Maps.api_key.nil?

        API.query(:places_service, args).predictions.map{|prediction| Place.new(prediction, keyword) }
      end
    end
    
  end
end