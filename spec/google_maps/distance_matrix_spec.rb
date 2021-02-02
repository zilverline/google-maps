# frozen_string_literal: true

require File.expand_path('../spec_helper', __dir__)

describe Google::Maps::DistanceMatrix do
  describe '.find' do
    subject { Google::Maps::DistanceMatrix.new('Amsterdam', 'Utrecht') }

    context ':nl' do
      before { stub_response('distance-matrix.json') }

      its(:distance) { should eq 53_744 }
      its(:duration) { should eq 3237 }
    end

    context ':nl and zero results' do
      before { stub_response('distance-matrix-zero-results.json') }

      it 'raises Google::Maps::ZeroResultsException' do

        expect { subject.distance }.to raise_error(Google::Maps::ZeroResultsException)
        expect { subject.duration }.to raise_error(Google::Maps::ZeroResultsException)

      end
    end
  end
end
