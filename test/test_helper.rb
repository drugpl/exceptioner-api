require "test/unit"
require "exceptioner_api/application"

ENV["RACK_ENV"] ||= "test"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

#  def valid_headers
#    {
#      "HTTP_API_KEY" => @project.api_key,
#      "HTTP_ACCEPT"  => "application/json",
#      "CONTENT_TYPE" => "application/json"
#    }
#  end
#
#  def valid_notice_params(error_params = nil)
#    {
#      message: "RuntimeError: booo!",
#      error: error_params || valid_error_params
#    }
#  end
#
#  def valid_error_params
#    {
#      exception: "RuntimeError"
#    }
#  end
#
#  def full_error_params
#    valid_error_params.merge(
#      session:     {"a" => 1},
#      parameters:  {"b" => 2},
#      environment: {"c" => 3},
#      backtrace:   ["first line", "second line"],
#      file: "[PROJECT_ROOT]/lib/exceptioner_api.rb",
#      mode: "production"
#    )
#  end
#
#  def valid_deploy_params
#    {
#      environment: "staging",
#      repository: "git@example.com:test/test.git",
#      revision: "abcd",
#      author: "John Doe"
#    }
#  end
#
#  def setup
#    @project = Exceptioner::Api::Models::Project.create(name: "Exceptioner")
#  end
#
#  def teardown
#    DatabaseCleaner.clean
#  end
#
#  def app
#    Exceptioner::Api::Application
#  end
#end
