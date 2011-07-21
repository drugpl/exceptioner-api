ENV["RACK_ENV"] ||= "test"

require "test/unit"
require "rack/test"
require "turn"
require "time"
require "exceptioner_api/application"

class Rack::MockResponse
  def payload
    parsed = JSON.parse(body)
    parsed.is_a?(Hash) ? parsed.with_indifferent_access : parsed
  end
end

class Exceptioner::Api::TestCase < Test::Unit::TestCase
  include Rack::Test::Methods

  def valid_headers
    {
      "HTTP_API_KEY" => @project.api_key,
      "HTTP_ACCEPT"  => "application/json",
      "CONTENT_TYPE" => "application/json"
    }
  end

  def setup
    Redis.new.flushdb # mock_redis should be used as soon as they implment sort
    @project = Exceptioner::Api::Models::Project.create(:name => "Exceptioner")
  end

  def app
    Exceptioner::Api::Application
  end
end
