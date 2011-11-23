require 'em-synchrony/em-http'
require 'test/unit'

class TestClient
  include Test::Unit::Assertions

  attr_reader :app_uri

  def initialize(options = {})
    host, port = ENV['EXCEPTIONER_HOST'], ENV['EXCEPTIONER_PORT'].to_i
    @app_uri   = "http://#{host}:#{port}"
    @options   = options
  end

  def get(path)
    data = EM::HttpRequest.new(File.join(app_uri, path)).get
    yield data if block_given?
    data
  end
end
