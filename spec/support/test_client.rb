require "rack/test"

class TestClient
  attr_reader :rack_test, :default_headers
  delegate :header, to: :rack_test

  def initialize(app, headers = {})
    @rack_test = ::TestClient::RackTest.new(app)
    @default_headers = headers
  end

  %w(get head post put patch delete).each do |method|
    define_method(method) do |path, params={}, headers={}|
      rack_test.send(method, path, params, default_headers.merge(headers))
    end
  end

  class RackTest
    attr_reader :app
    include Rack::Test::Methods

    def initialize(app)
      @app = app
    end
  end
end

