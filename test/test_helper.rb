ENV["RACK_ENV"] ||= "test"

require "test/unit"
require "rack/test"
require "turn"
require "time"
require "exceptioner_api/application"
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

class Rack::MockResponse
  def payload
    parsed = JSON.parse(body)
    case parsed
    when Hash
      parsed.with_indifferent_access
    when Array
      parsed.collect { |elem| elem.with_indifferent_access }
    end
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

  def valid_notice_params(error_params = nil)
    {
      message: "RuntimeError: booo!",
      error: error_params || valid_error_params
    }
  end

  def valid_error_params
    {
      exception: "RuntimeError"
    }
  end

  def full_error_params
    valid_error_params.merge(
      session:     {"a" => 1},
      parameters:  {"b" => 2},
      environment: {"c" => 3},
      backtrace:   ["first line", "second line"],
      file: "[PROJECT_ROOT]/lib/exceptioner_api.rb",
      mode: "production"
    )
  end

  def valid_deploy_params
    {
      environment: "staging",
      repository: "git@example.com:test/test.git",
      revision: "abcd",
      author: "John Doe"
    }
  end

  def setup
    @project = Exceptioner::Api::Models::Project.create(name: "Exceptioner")
  end

  def teardown
    DatabaseCleaner.clean
  end

  def app
    Rack::Builder.new do
      use Rack::Config do |env|
        env['api.tilt.root'] = File.join(File.dirname(__FILE__), "..", "views")
      end
      run Exceptioner::Api::Application
    end
  end
end
