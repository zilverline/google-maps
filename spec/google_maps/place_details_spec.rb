# frozen_string_literal: true

require File.expand_path('../spec_helper', __dir__)

describe Google::Maps::PlaceDetails do
  let(:place_id) do
    'CpQBiAAAAGs4XDizjQoVk9NjuY3ll3aLBLafpDxaFPSJSO7icOj07' \
    'IRHO4KjjcRIbKEmeSVTcG75kIvwqE7VzA8D7BFvWp8OPwgAiKMveQ' \
    'QUsTGfJrRG5EVd7J34hY8e5JDbaXEPOMUPIWLfiugwUfQqAImvWQC' \
    'GrMG1iyOpZfaW22NNhornssEg90uxrLbwLJ7QZhwGIRIQSBc_BlD7' \
    'mILqQaixzTqE1BoUbNrhbmsZYkIurvK4l9exKBryfKk'
  end

  context 'given a canned response' do
    before(:each) do
      stub_response('place_details.json')
      @details = Google::Maps::PlaceDetails.find(place_id, :nl)
    end

    it 'should have a place_id' do
      expect(@details.place_id).to eq(place_id)
    end

    it 'should have a latlong' do
      expect(@details.latitude).to eq('-33.866975')
      expect(@details.longitude).to eq('151.195677')
    end

    it 'has data containing at least address components' do
      expect(@details.data.address_components).not_to be_empty
    end

    context '#address_components' do
      it 'allows easy access by type' do
        expect(@details.address_components.postal_code.long_name).to eq '2009'
        expect(@details.address_components.locality.long_name).to eq 'Pyrmont'
      end
    end
  end
end
