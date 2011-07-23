if defined?(EM) && EM.reactor_running?
  require 'em-synchrony/em-mongo'
  Mongo = EM::Mongo
else
  require 'mongo'
end

require 'mongoid'
