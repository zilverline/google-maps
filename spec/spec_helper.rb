require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'rspec/its'
require 'rspec/collection_matchers'
require 'simplecov'

SimpleCov.start do
  add_group 'GoogleMaps', 'lib/google-maps'
  add_group 'Specs', 'spec'
  add_filter __FILE__
end

RSpec.configure do |config|
  config.mock_with :mocha

  config.before(:each) do
    # catch all unmocked requests
    HTTPClient.any_instance.expects(:get_content).never
  end

  config.after(:each) do
    # reset mock
    HTTPClient.any_instance.unstub(:get_content)

    # reset configuration
    Google::Maps.reset
  end
end

def stub_response(fixture, url = nil)
  fixture_path = File.expand_path("../fixtures/#{fixture}", __FILE__)
  expectation = HTTPClient.any_instance.expects(:get_content)
  expectation.with(url) if url
  expectation.returns(File.open(fixture_path, "rb").read)
end

load File.expand_path('../../lib/google-maps.rb', __FILE__)
