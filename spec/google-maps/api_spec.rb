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
  
  describe "premier usage" do
    before :each do 
      Google::Maps.configure do |config|
        config.premier_client_id = "clientID"
        config.premier_key = "vNIXE0xscrmjlyV-12Nj_BvUPaw="
      end
    end
    
    it "should raise an exception when a client id is set but no key" do
      Google::Maps.premier_key = nil
      lambda{ Google::Maps.distance("Amsterdam", "Deventer") }.should raise_error(Google::Maps::InvalidPremierConfigurationException)
    end
    
    it "should sign the url parameters when a client id and premier key is set" do
      # http://code.google.com/apis/maps/documentation/webservices/index.html#URLSigning

      # Example:
      # Private Key: vNIXE0xscrmjlyV-12Nj_BvUPaw=
      # Signature: KrU1TzVQM7Ur0i8i7K3huiw3MsA=
      # Client ID: clientID
      # URL: http://maps.googleapis.com/maps/api/geocode/json?address=New+York&sensor=false&client=clientID
      url = "http://maps.google.com/maps/api/geocode/json?address=New+York&sensor=false&client=clientID"
      signed_url = Google::Maps::API.send(:premier_signing, url)
      signed_url.should == "#{url}&signature=KrU1TzVQM7Ur0i8i7K3huiw3MsA="
    end
  end

end