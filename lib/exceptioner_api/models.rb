require 'exceptioner_api'
require 'supermodel'
require 'em-synchrony/em-redis'

Redis = EM::Protocols::Redis

module Exceptioner::Api
  module Models
    class Base < SuperModel::Base
      include SuperModel::Redis::Model
    end
  end
end
