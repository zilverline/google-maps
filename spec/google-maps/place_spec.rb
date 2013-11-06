require File.expand_path('../../spec_helper', __FILE__)

describe Google::Maps::Place do
  before(:each) do
    stub_response("deventer-nl.json")
    @places = Google::Maps::Place.find("Deventer \\", :nl)
  end

  it "should have a description" do
    @places.first.text.should == "Deventer, Nederland"
  end

  it "should have a html description with hightlighted keywords" do
    @places.first.html.should == "<strong>Deventer</strong>, Nederland"
  end

  it "should be able to present the text in English" do
    stub_response("deventer-en.json")
    places = Google::Maps::Place.find("Deventer", :en)
    places.first.text.should == "Deventer, The Netherlands"
  end
end
