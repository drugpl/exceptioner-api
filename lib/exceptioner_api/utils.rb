require 'exceptioner_api'
require 'digest/sha1'

module Exceptioner
  module Api
    module Utils
      class FingerprintGenerator
        def initialize(*attributes)
          @data = attributes.join
        end

        def generate
          Digest::SHA1.hexdigest(@data)
        end
      end
    end
  end
end
