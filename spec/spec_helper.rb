ENV['RACK_ENV'] ||= 'test'

require 'bundler/setup'
require 'rspec/api'
require 'exceptioner_api/application'
require 'webmachine/adapters/rack'
require_relative 'support/test_client'

rack_app = Exceptioner::Api::Application.new(adapter: :Rack).adapter

RSpec.configure do |c|
  c.before(:all) do
    @test_client = TestClient.new(rack_app)
  end
end
