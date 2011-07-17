require 'exceptioner_api'
require 'supermodel'

if defined?(EM) && EM.reactor_running?
  require 'em-synchrony/em-redis'
  Redis = EM::Protocols::Redis
else
  require 'redis'
end

module Exceptioner::Api
  module Models
    class Base < SuperModel::Base
      include SuperModel::Redis::Model
      include SuperModel::Timestamp::Model
      include ActiveModel::Validations::Callbacks
    end
  end
end
