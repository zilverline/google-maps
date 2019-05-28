# frozen_string_literal: true

require File.expand_path('spec_helper', __dir__)

describe Google::Maps do
  describe 'Directions' do
    before(:each) do
      stub_response('amsterdam-deventer-en.json')
    end

    it 'should be able to calculate a route' do
      route = Google::Maps.route('Science Park, Amsterdam', 'Deventer')
      expect(route.class).to eq(Google::Maps::Route)
      expect(route.distance.text).to eq('104 km')
      expect(route.duration.text).to eq('1 hour 12 mins')
      expect(route.distance.value).to eq(103_712)
      expect(route.duration.value).to eq(4337)
    end

    it 'should be able to calculate the distance' do
      expect(Google::Maps.distance('Science Park, Amsterdam', 'Deventer')).to eq('104 km')
    end

    it 'should be able to calculate the duration' do
      expect(Google::Maps.duration('Science Park, Amsterdam', 'Deventer')).to eq('1 hour 12 mins')
    end
  end

  describe 'Places' do
    before(:each) do
      stub_response('deventer-en.json')
    end

    it 'should find a list of places for a keyword' do
      place = Google::Maps.places('Deventer').first
      expect(place.class).to eq(Google::Maps::Place)
      expect(place.text).to eq('Deventer, The Netherlands')
      expect(place.html).to eq('<strong>Deventer</strong>, The Netherlands')
    end
  end

  describe 'Geocoder' do
    it 'should lookup a latlong for an address' do
      stub_response('geocoder/science-park-400-amsterdam-en.json')

      location = Google::Maps.geocode('Science Park 400, Amsterdam').first
      expect(location.class).to eq(Google::Maps::Location)
      expect(location.address).to eq('Science Park Amsterdam 400, University of Amsterdam, 1098 XH Amsterdam, The Netherlands')
      expect(location.latitude).to eq(52.3564490)
      expect(location.longitude).to eq(4.95568890)

      expect(location.lat_lng).to eq([52.3564490, 4.95568890])
    end

    it 'should extract all components for an address' do
      stub_response('geocoder/science-park-400-amsterdam-en.json')

      location = Google::Maps.geocode('Science Park 400, Amsterdam').first
      components = location.components
      expect(components['administrative_area_level_1']).to eq(['Noord-Holland'])
      expect(components['administrative_area_level_2']).to eq(['Government of Amsterdam'])
      expect(components['country']).to eq(['The Netherlands'])
      expect(components['establishment']).to eq(['University of Amsterdam'])
      expect(components['locality']).to eq(['Amsterdam'])
      expect(components['political']).to eq(
        ['Middenmeer', 'Watergraafsmeer', 'Amsterdam', 'Government of Amsterdam', 'Noord-Holland', 'The Netherlands']
      )
      expect(components['postal_code']).to eq(['1098 XH'])
      expect(components['route']).to eq(['Science Park Amsterdam'])
      expect(components['street_number']).to eq(['400'])
      expect(components['sublocality']).to eq(['Middenmeer', 'Watergraafsmeer'])
    end

    it 'should handle multiple location for an address' do
      stub_response('geocoder/amsterdam-en.json')

      locations = Google::Maps.geocode('Amsterdam')
      expect(locations).to have(2).items
      location = locations.last
      expect(location.address).to eq('Amsterdam, NY, USA')
      expect(location.latitude).to eq(42.93868560)
      expect(location.longitude).to eq(-74.18818580)
    end

    it 'should accept languages other than en' do
      stub_response('geocoder/science-park-400-amsterdam-nl.json')

      location = Google::Maps.geocode('Science Park 400, Amsterdam', :nl).first
      expect(location.address).to eq('Science Park 400, Amsterdam, 1098 XH Amsterdam, Nederland')
    end

    it 'should return an empty array when an address could not be geocoded' do
      stub_response('zero-results.json')

      expect(Google::Maps.geocode('Amsterdam')).to eq([])
    end
  end

  describe '.end_point=' do
    it 'should set the end_point' do
      Google::Maps.end_point = 'http://maps.google.com/'
      expect(Google::Maps.end_point).to eq('http://maps.google.com/')
    end
  end

  describe '.options' do
    it 'should return a hash with the current settings' do
      Google::Maps.end_point = 'test end point'
      Google::Maps.options == { end_point: 'test end point' }
    end
  end

  describe '.configure' do
    it 'has constants for the authentication methods' do
      expect(Google::Maps::Configuration::API_KEY).to eq 'api_key'
      expect(Google::Maps::Configuration::DIGITAL_SIGNATURE).to eq 'digital_signature'
    end

    context 'api key configuration' do
      it 'is be possible to set configuration with an api key' do
        Google::Maps.configure do |config|
          config.authentication_mode = Google::Maps::Configuration::API_KEY
          config.api_key = 'xxxxxxxxxxx'
        end

        expect(Google::Maps.authentication_mode).to eq(Google::Maps::Configuration::API_KEY)
        expect(Google::Maps.api_key).to eq('xxxxxxxxxxx')
      end

      it 'fails when no api key is provided' do
        expect do
          Google::Maps.configure do |config|
            config.authentication_mode = Google::Maps::Configuration::API_KEY
          end
        end.to raise_error(Google::Maps::InvalidConfigurationError)
      end
    end

    context 'digital signature configuration' do
      it 'is be possible to set configuration with an api key' do
        Google::Maps.configure do |config|
          config.authentication_mode = Google::Maps::Configuration::DIGITAL_SIGNATURE
          config.client_id = 'xxxxxxxxxxx'
          config.client_secret = 'xxxxxxxxxxx'
        end

        expect(Google::Maps.authentication_mode).to eq(Google::Maps::Configuration::DIGITAL_SIGNATURE)
        expect(Google::Maps.client_id).to eq('xxxxxxxxxxx')
        expect(Google::Maps.client_secret).to eq('xxxxxxxxxxx')
      end

      it 'fails when no client id is provided' do
        expect do
          Google::Maps.configure do |config|
            config.authentication_mode = Google::Maps::Configuration::DIGITAL_SIGNATURE
            config.client_secret = 'xxxxxxxxxxx'
          end
        end.to raise_error(Google::Maps::InvalidConfigurationError)
      end

      it 'fails when no client secret is provided' do
        expect do
          Google::Maps.configure do |config|
            config.authentication_mode = Google::Maps::Configuration::DIGITAL_SIGNATURE
            config.client_id = 'xxxxxxxxxxx'
          end
        end.to raise_error(Google::Maps::InvalidConfigurationError)
      end
    end

    context 'with invalid authentication mode' do
      it 'raises an invalid configuration exception' do
        expect do
          Google::Maps.configure do |config|
            config.authentication_mode = 'hack'
            config.client_secret = 'xxxxxxxxxxx'
          end
        end.to raise_error(Google::Maps::InvalidConfigurationError)
      end
    end

    Google::Maps::Configuration::VALID_OPTIONS_KEYS.reject { |x| x == :authentication_mode }.each do |key|
      it "should set the #{key}" do
        Google::Maps.configure do |config|
          config.authentication_mode = Google::Maps::Configuration::API_KEY
          config.api_key = 'xxxxxxxxxxx'
          config.send("#{key}=", key)
          expect(Google::Maps.send(key)).to eq(key)
        end
      end
    end
  end
end
