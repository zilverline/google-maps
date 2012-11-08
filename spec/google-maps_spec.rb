require File.expand_path('../spec_helper', __FILE__)

describe Google::Maps do
  
  describe "Directions" do
    before(:each) do
      stub_response("amsterdam-deventer-en.json")
    end
  
    it "should be able to calculate a route" do
      route = Google::Maps.route("Science Park, Amsterdam", "Deventer")
      route.class.should == Google::Maps::Route
      route.distance.text.should == "104 km"
      route.duration.text.should == "1 hour 12 mins"
      route.distance.value.should == 103712
      route.duration.value.should == 4337
    end

    it "should be able to calculate the distance" do
      Google::Maps.distance("Science Park, Amsterdam", "Deventer").should == "104 km"
    end

    it "should be able to calculate the duration" do
      Google::Maps.duration("Science Park, Amsterdam", "Deventer").should == "1 hour 12 mins"
    end
  end
  
  describe "Places" do  
    before(:each) do
      stub_response("deventer-en.json")
    end
    
    it "should find a list of places for a keyword" do
      place = Google::Maps.places("Deventer").first
      place.class.should == Google::Maps::Place
      place.text.should == "Deventer, The Netherlands"
      place.html.should == "<strong>Deventer</strong>, The Netherlands"
    end
  end

  describe "Geocoder" do
    it "should lookup a latlong for an address" do
      stub_response("geocoder/science-park-400-amsterdam-en.json")

      location = Google::Maps.geocode("Science Park 400, Amsterdam").first
      location.class.should == Google::Maps::Location
      location.address.should == "Science Park Amsterdam 400, University of Amsterdam, 1098 XH Amsterdam, The Netherlands"
      location.latitude.should == 52.3564490
      location.longitude.should == 4.95568890

      location.lat_lng.should == [52.3564490, 4.95568890]
    end

    it "should handle multiple location for an address" do
      stub_response("geocoder/amsterdam-en.json")

      locations = Google::Maps.geocode("Amsterdam")
      locations.should have(2).items
      location = locations.last
      location.address.should == "Amsterdam, NY, USA"
      location.latitude.should == 42.93868560
      location.longitude.should == -74.18818580
    end

    it "should accept languages other than en" do
      stub_response("geocoder/science-park-400-amsterdam-nl.json")

      location = Google::Maps.geocode("Science Park 400, Amsterdam", :nl).first
      location.address.should == "Science Park 400, Amsterdam, 1098 XH Amsterdam, Nederland"
    end

    it "should return an empty array when an address could not be geocoded" do
      stub_response("zero-results.json")

      Google::Maps.geocode("Amsterdam").should == []
    end
  end
  
  describe ".end_point=" do
    it "should set the end_point" do
      Google::Maps.end_point = "http://maps.google.com/"
      Google::Maps.end_point.should == "http://maps.google.com/"
    end
  end
  
  describe ".options" do
    it "should return a hash with the current settings" do
      Google::Maps.end_point = "test end point"
      Google::Maps.options == {:end_point => "test end point"}
    end
  end

  describe ".configure" do
    Google::Maps::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        Google::Maps.configure do |config|
          config.send("#{key}=", key)
          Google::Maps.send(key).should == key
        end
      end
    end
  end
end