require File.expand_path('../api', __FILE__)

module Google
  module Maps
    
    class Place
      attr_reader :text, :html, :keyword
      alias :to_s :text
      alias :to_html :html
      
      def initialize(data, keyword)
        @text = data.description
        @html = data.description.gsub(/(#{keyword})/i, '<strong>\1</strong>')
      end
      
      def self.find(keyword, language=:en)
        API.query(:places_service, :language => language, :input => keyword, :key => Google::Maps.api_key).predictions.map{|prediction| Place.new(prediction, keyword) }
      end
    end
    
  end
end