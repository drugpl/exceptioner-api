require 'goliath/server'

Goliath.env = :test

# very nasty hack, but I like to test the other way
# than Goliath guys suggest
class Goliath::Server
  # does not start reactor nor loads plugins
  def start(&blk)
    EM.start_server(address, port, Goliath::Connection) do |conn|
      conn.port    = port
      conn.app     = app
      conn.api     = api
      conn.logger  = logger
      conn.status  = status
      conn.config  = config
      conn.options = options
    end
  end
end
