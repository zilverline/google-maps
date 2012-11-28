require File.expand_path('../../spec_helper', __FILE__)

describe Google::Maps::PlaceDetails do
  before(:each) do
    stub_response("place_details.json")
    @reference = "CpQBiAAAAGs4XDizjQoVk9NjuY3ll3aLBLafpDxaFPSJSO7icOj07IRHO4KjjcRIbKEmeSVTcG75kIvwqE7VzA8D7BFvWp8OPwgAiKMveQQUsTGfJrRG5EVd7J34hY8e5JDbaXEPOMUPIWLfiugwUfQqAImvWQCGrMG1iyOpZfaW22NNhornssEg90uxrLbwLJ7QZhwGIRIQSBc_BlD7mILqQaixzTqE1BoUbNrhbmsZYkIurvK4l9exKBryfKk"
    @details = Google::Maps::PlaceDetails.find(@reference, :nl)
  end

  it "should have a reference" do
    @details.reference.should == @reference
  end

  it "should have a latlong" do
    @details.latitude.should == "-33.866975"
    @details.longitude.should =="151.195677"
  end


end