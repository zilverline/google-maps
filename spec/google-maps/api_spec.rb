require File.expand_path('../../spec_helper', __FILE__)

describe Google::Maps::API do
  it "should raise a custom exception when the query fails by net" do
    HTTPClient.any_instance.unstub(:get_content)
    
    Google::Maps.end_point = "http://unknown.tld/"
    lambda{ Google::Maps.distance("Amsterdam", "Deventer") }.should raise_error(Google::Maps::InvalidResponseException)
    Google::Maps.end_point = "http://unknown-domain-asdasdasdas123123zxcasd.com/"
    lambda{ Google::Maps.distance("Amsterdam", "Deventer") }.should raise_error(Google::Maps::InvalidResponseException)
    Google::Maps.end_point = "http://www.google.com/404"
    lambda{ Google::Maps.distance("Amsterdam", "Deventer") }.should raise_error(Google::Maps::InvalidResponseException)

  end
  
  it "should raise a custom exception when the query fails by Google" do
    stub_response("over_query_limit.json")
    lambda{ Google::Maps.distance("Amsterdam", "Deventer") }.should raise_error(Google::Maps::InvalidResponseException)    
  end
end