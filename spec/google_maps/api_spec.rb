# frozen_string_literal: true

require File.expand_path('../spec_helper', __dir__)

describe Google::Maps::API do
  it 'should raise a custom exception when the query fails by net' do
    HTTPClient.any_instance.unstub(:get_content)

    Google::Maps.end_point = 'http://unknown.tld/'
    expect { Google::Maps.distance('Amsterdam', 'Deventer') }.to raise_error(Google::Maps::InvalidResponseException)
    Google::Maps.end_point = 'http://unknown-domain-asdasdasdas123123zxcasd.com/'
    expect { Google::Maps.distance('Amsterdam', 'Deventer') }.to raise_error(Google::Maps::InvalidResponseException)
    Google::Maps.end_point = 'http://www.google.com/404'
    expect { Google::Maps.distance('Amsterdam', 'Deventer') }.to raise_error(Google::Maps::InvalidResponseException)
  end

  it 'should raise a custom exception when the query fails by Google' do
    stub_response('over_query_limit.json')
    expect { Google::Maps.distance('Amsterdam', 'Deventer') }.to raise_error(Google::Maps::InvalidResponseException)
  end

  it 'should raise a custom exception when there are no results' do
    stub_response('zero-results.json')
    expect { Google::Maps.distance('Blah blah', 'Jalala') }.to raise_error(Google::Maps::ZeroResultsException)
  end

  it 'should raise a custom exception that is rescue-able' do
    stub_response('zero-results.json')
    begin
      Google::Maps.distance('Blah blah', 'Jalala')
    rescue StandardError => e
      @error = e
    ensure
      expect(@error).not_to be_nil
      expect(@error).to be_a_kind_of StandardError
    end
  end

  describe 'authentication' do
    context 'with digital signature' do
      before do
        Google::Maps.configure do |config|
          config.authentication_mode = Google::Maps::Configuration::DIGITAL_SIGNATURE
          config.client_id = 'clientID'
          config.client_secret = 'vNIXE0xscrmjlyV-12Nj_BvUPaw='
        end
      end

      it 'should sign the url parameters when a client id and premier key is set' do
        stub_response(
          'place_details.json',
          'https://maps.googleapis.com/maps/api/geocode/json?address=New+York&client=clientID&signature=chaRF2hTJKOScPr-RQCEhZbSzIE='
        )
        # http://code.google.com/apis/maps/documentation/webservices/index.html#URLSigning

        # Example:
        # Private Key: vNIXE0xscrmjlyV-12Nj_BvUPaw=
        # Signature: chaRF2hTJKOScPr-RQCEhZbSzIE=
        # Client ID: clientID
        # URL: http://maps.googleapis.com/maps/api/geocode/json?address=New+York&client=clientID
        Google::Maps::API.query(:geocode_service, address: 'New York')
      end
    end

    context 'with api key' do
      before do
        Google::Maps.configure do |config|
          config.authentication_mode = Google::Maps::Configuration::API_KEY
          config.api_key = 'api_key123'
        end
      end

      it 'should sign the url parameters when a client id and premier key is set' do
        stub_response(
          'place_details.json',
          'https://maps.googleapis.com/maps/api/geocode/json?address=New+York&key=api_key123'
        )
        Google::Maps::API.query(:geocode_service, address: 'New York')
      end
    end
  end
end
