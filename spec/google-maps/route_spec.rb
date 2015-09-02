require File.expand_path('../../spec_helper', __FILE__)

describe Google::Maps::Route do
  describe "dutch" do
    before(:each) do
      stub_response("amsterdam-deventer-nl.json")
      @route = Google::Maps::Route.new("Science Park, Amsterdam", "Deventer", :nl)
    end

    it "should be able to calculate a route" do
      @route.distance.text.should == "104 km"
      @route.duration.text.should == "1 uur 12 min."
      @route.distance.value.should == 103712
      @route.duration.value.should == 4337
    end

    it "should be able to present the text in Dutch" do
      @route.options[:language].should == :nl
      @route.end_address.should == "Deventer, Nederland"
    end

    it "should be able to return the address for the origin" do
      @route.start_address.should == "Science Park, 1098 Amsterdam, Nederland"
    end

    it "should be able to return the address for the destination" do
      @route.end_address.should == "Deventer, Nederland"
    end

    it "should be able to return the latiude and longitude for the origin" do
      @route.start_location.lat.should == 52.35445000000001
      @route.start_location.lng.should == 4.95420
      @route.origin_latlong.should == "52.35445000000001,4.9542"
    end

    it "should be able to return the latiude and longitude for the destination" do
      @route.end_location.lat.should == 52.25441000000001
      @route.end_location.lng.should == 6.160470
      @route.destination_latlong.should == "52.25441000000001,6.16047"
    end
  end

  describe "english" do
    it "should be able to present the text in English" do
      stub_response("amsterdam-deventer-en.json")
      route = Google::Maps::Route.new("Science Park, Amsterdam", "Deventer", :en)
      route.options[:language].should == :en
      route.end_address.should == "Deventer, The Netherlands"
    end
  end

end
