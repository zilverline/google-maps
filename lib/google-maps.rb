require File.expand_path('../google-maps/configuration', __FILE__)
require File.expand_path('../google-maps/route', __FILE__)
require File.expand_path('../google-maps/place', __FILE__)

module Google
  module Maps
    extend Configuration
    
    def self.route(from, to)
      Route.new(from, to)
    end
    
    def self.distance(from, to)
      Route.new(from, to).distance.text
    end
    
    def self.duration(from, to)
      Route.new(from, to).duration.text
    end
    
    def self.places(keyword)
      Place.find(keyword)
    end
  end
end
