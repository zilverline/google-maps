require File.expand_path('../../spec_helper', __FILE__)
require 'logger'

describe Google::Maps::Logger do
  it "should be able to log messages when a log output is set" do
    # fake an exception
    HTTPClient.any_instance.expects(:get_content).raises("test exception")
    
    # expect the logger to be called once
    Logger.any_instance.expects(:error).at_least_once

    # trigger the exception
    lambda{ Google::Maps.distance("Amsterdam", "Deventer") }.should raise_error
  end
end