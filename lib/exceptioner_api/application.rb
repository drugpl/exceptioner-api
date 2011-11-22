require 'exceptioner_api'

class Exceptioner::API::Application < Goliath::API
  def response(env)
    [200, {}, "exceptioner-api FTW!"]
  end
end
