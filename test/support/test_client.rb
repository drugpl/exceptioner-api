require "webmachine/test"
require "forwardable"

class TestClient
  extend Forwardable

  attr_reader :webmachine_test

  def_delegators :webmachine_test, :get, :post, :put, :patch, :delete, :head, :header

  def initialize(app, headers = {})
    @webmachine_test = ::TestClient::WebmachineTest.new(app)
    headers.each { |k, v| @webmachine_test.header(k, v) }
  end

  class WebmachineTest
    attr_reader :app
    include Webmachine::Test

    def initialize(app)
      @app = app
    end
  end
end

