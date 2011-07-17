ENV["RACK_ENV"] ||= "test"

require "test/unit"
require "rack/test"
require "turn"
require "exceptioner_api/application"


class Rack::MockResponse
  def body_with_json
    JSON.parse(body_without_json).with_indifferent_access
  end

  alias_method_chain :body, :json
end

class Exceptioner::Api::TestCase < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Exceptioner::Api::Application
  end
end
