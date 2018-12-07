# frozen_string_literal: true

require File.expand_path('../spec_helper', __dir__)

describe Google::Maps::Route do
  describe 'dutch' do
    before(:each) do
      stub_response('amsterdam-deventer-nl.json')
      @route = Google::Maps::Route.new('Science Park, Amsterdam', 'Deventer', :nl)
    end

    it 'should be able to calculate a route' do
      expect(@route.distance.text).to eq('104 km')
      expect(@route.duration.text).to eq('1 uur 12 min.')
      expect(@route.distance.value).to eq(103_712)
      expect(@route.duration.value).to eq(4337)
    end

    it 'should be able to present the text in Dutch' do
      expect(@route.options[:language]).to eq(:nl)
      expect(@route.end_address).to eq('Deventer, Nederland')
    end

    it 'should be able to return the address for the origin' do
      expect(@route.start_address).to eq('Science Park, 1098 Amsterdam, Nederland')
    end

    it 'should be able to return the address for the destination' do
      expect(@route.end_address).to eq('Deventer, Nederland')
    end

    it 'should be able to return the latiude and longitude for the origin' do
      expect(@route.start_location.lat).to eq(52.35445000000001)
      expect(@route.start_location.lng).to eq(4.95420)
      expect(@route.origin_latlong).to eq('52.35445000000001,4.9542')
    end

    it 'should be able to return the latiude and longitude for the destination' do
      expect(@route.end_location.lat).to eq(52.25441000000001)
      expect(@route.end_location.lng).to eq(6.160470)
      expect(@route.destination_latlong).to eq('52.25441000000001,6.16047')
    end
  end

  describe 'english' do
    it 'should be able to present the text in English' do
      stub_response('amsterdam-deventer-en.json')
      route = Google::Maps::Route.new('Science Park, Amsterdam', 'Deventer', :en)
      expect(route.options[:language]).to eq(:en)
      expect(route.end_address).to eq('Deventer, The Netherlands')
    end
  end
end
