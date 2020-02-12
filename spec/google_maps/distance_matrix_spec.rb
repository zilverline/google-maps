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
  end
end
