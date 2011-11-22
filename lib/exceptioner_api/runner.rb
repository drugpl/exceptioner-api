require 'exceptioner_api/application'
require 'goliath/runner'

class Exceptioner::API::Runner
  def initialize(params)
    klass = Exceptioner::API::Application
    api   = klass.new
    @runner     = Goliath::Runner.new(params, api)
    @runner.app = Goliath::Rack::Builder.build(klass, api)
    @runner.load_plugins(klass.plugins)
  end

  def run
    @runner.run
  end
end


