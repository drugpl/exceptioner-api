require 'em-spec/test'
require 'exceptioner_api/application'
require 'logger'

ENV['EXCEPTIONER_HOST'] ||= '127.0.0.1'
ENV['EXCEPTIONER_PORT'] ||= '1234'

class Exceptioner::API::TestCase < Test::Unit::TestCase
  include EM::TestHelper

  attr_reader :app_uri

  def run(result, &block)
    host, port = ENV['EXCEPTIONER_HOST'], ENV['EXCEPTIONER_PORT'].to_i
    klass      = Exceptioner::API::Application
    server     = Goliath::Server.new(host, port)
    server.logger  = Logger.new('/dev/null')
    server.app     = Goliath::Rack::Builder.build(klass, klass.new)
    server.api     = klass.new
    server.plugins = []
    server.options = {}

    em do
      server.start
      output = begin
                 super
               ensure
                 done
               end
      output
    end
  end
end
