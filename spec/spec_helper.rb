ENV['RACK_ENV'] ||= 'test'

require 'bundler/setup'
require 'rspec/api'
require 'exceptioner_api/application'
require 'webmachine/adapters/rack'
require 'database_cleaner'
require 'factories'
require_relative 'support/test_client'

rack_app = Exceptioner::Api::Application.new(adapter: :Rack).adapter

RSpec.configure do |c|
  c.before(:all) do
    @test_client = TestClient.new(rack_app)
    @test_client.header('Accept', 'application/json')
    @test_client.header('Content-Type', 'application/json')
  end

  c.after(:each) { DatabaseCleaner.clean }
  c.include FactoryGirl::Syntax::Methods
end
