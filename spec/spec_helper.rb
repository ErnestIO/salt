# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'pry'
require 'webmock/rspec'
require "#{Dir.pwd}/lib/salt.rb"

WebMock.disable_net_connect!(allow_localhost: true)

def json_response_for(type)
  { body: File.read("#{Dir.pwd}/spec/lib/json_responses/#{type}.json").to_s }
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    stub_request(:post, 'https://127.0.0.1:8000/login')
      .to_return(json_response_for(:auth))
  end
end
