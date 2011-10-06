require File.expand_path('../spec_helper', __FILE__)

describe Google::Maps do
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