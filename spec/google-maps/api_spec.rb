require File.expand_path('../../spec_helper', __FILE__)

describe Google::Maps::API do
  it "should raise a custom exception when the query fails by net" do
    HTTPClient.any_instance.unstub(:get_content)
    
    Google::Maps.end_point = "http://unknown.tld/"
    expect{ Google::Maps.distance("Amsterdam", "Deventer") }.to raise_error(Google::Maps::InvalidResponseException)
    Google::Maps.end_point = "http://unknown-domain-asdasdasdas123123zxcasd.com/"
    expect{ Google::Maps.distance("Amsterdam", "Deventer") }.to raise_error(Google::Maps::InvalidResponseException)
    Google::Maps.end_point = "http://www.google.com/404"
    expect{ Google::Maps.distance("Amsterdam", "Deventer") }.to raise_error(Google::Maps::InvalidResponseException)
  end

  it "should raise a custom exception when the query fails by Google" do
    stub_response("over_query_limit.json")
    expect{ Google::Maps.distance("Amsterdam", "Deventer") }.to raise_error(Google::Maps::InvalidResponseException)    
  end

  it "should raise a custom exception when there are no results" do
    stub_response("zero-results.json")
    expect{ Google::Maps.distance("Blah blah", "Jalala") }.to raise_error(Google::Maps::ZeroResultsException)
  end

  it "should raise a custom exception that is rescue-able" do
    stub_response("zero-results.json")
    begin
      Google::Maps.distance("Blah blah", "Jalala")
    rescue => error
      @error = error
    ensure
      expect(@error).not_to be_nil
      expect(@error).to be_a_kind_of StandardError
    end
  end

  describe "premier signing" do
    before :each do 
      Google::Maps.configure do |config|
        config.premier_client_id = "clientID"
        config.premier_key = "vNIXE0xscrmjlyV-12Nj_BvUPaw="
      end
    end
    
    it "should raise an exception when a client id is set but no key" do
      Google::Maps.premier_key = nil
      expect{ Google::Maps.distance("Amsterdam", "Deventer") }.to raise_error(Google::Maps::InvalidPremierConfigurationException)
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
      expect(signed_url).to eq("#{url}&signature=KrU1TzVQM7Ur0i8i7K3huiw3MsA=")
    end
    
    it "should allow a parsed URI object to be used for signing" do
      url = URI.parse("http://maps.google.com/maps/api/geocode/json?address=New+York&sensor=false&client=clientID")
      signed_url = Google::Maps::API.send(:premier_signing, url)
      expect(signed_url).to eq("#{url}&signature=KrU1TzVQM7Ur0i8i7K3huiw3MsA=")
    end

    context "per service overrides" do
      let(:place_id) { "CpQBiAAAAGs4XDizjQoVk9NjuY3ll3aLBLafpDxaFPSJSO7icOj07IRHO4KjjcRIbKEmeSVTcG75kIvwqE7VzA8D7BFvWp8OPwgAiKMveQQUsTGfJrRG5EVd7J34hY8e5JDbaXEPOMUPIWLfiugwUfQqAImvWQCGrMG1iyOpZfaW22NNhornssEg90uxrLbwLJ7QZhwGIRIQSBc_BlD7mILqQaixzTqE1BoUbNrhbmsZYkIurvK4l9exKBryfKk" }
      let(:api_key) { "some_api_key" }
      let(:parameters) { [:premier_client_id, :premier_key, :api_key, :default_params] }

      before :each do
        parameters.each do |what|
          self.instance_variable_set(:"@old_#{what}", Google::Maps.send(what))
        end

        Google::Maps.configure do |config|
          config.premier_client_id = "gme-test"
          config.premier_key = "secret"
          config.api_key = api_key
          config.default_params = {place_details_service: {:use_premier_signing => false}}
        end
      end

      after :each do
        Google::Maps.configure do |config|
          parameters.each do |what|
            config.send(:"#{what}=", self.instance_variable_get(:"@old_#{what}"))
          end
        end
      end

      it "should not be used when configured for a certain service" do
        stub_response("place_details.json", "https://maps.googleapis.com/maps/api/place/details/json?sensor=false&language=nl&placeid=#{place_id}&key=#{api_key}")

        expect(Google::Maps::place(place_id, :nl)).not_to be_nil
      end
    end
  end

end
