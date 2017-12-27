require 'coveralls'
Coveralls.wear_merged!

require 'rack/test'
require 'shedcam'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  include Rack::Test::Methods
  def app
    Shedcam::App
  end
end
