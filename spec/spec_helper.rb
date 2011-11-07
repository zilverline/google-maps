require 'rspec'
require 'simplecov'
SimpleCov.start do
  add_group 'GoogleMaps', 'lib/google-maps'
  add_group 'Specs', 'spec'
  add_filter __FILE__
end

RSpec.configure do |config|
  config.mock_with :mocha
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  
  config.before(:each) do
    # catch all non-mocked requests
    Net::HTTP.expects(:get_response).never
  end
end

def stub_response(fixture)
  fixture_path = File.expand_path("../fixtures/#{fixture}", __FILE__)
  response = stub(:kind_of? => Net::HTTPSuccess, :body => File.open(fixture_path, "rb").read)
  Net::HTTP.stubs(:get_response).returns(response)
end

load File.expand_path('../../lib/google-maps.rb', __FILE__)