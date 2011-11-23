require 'exceptioner_api'
require 'digest/sha1'

class Exceptioner::API::FingerprintGenerator
  def initialize(*attributes)
    @data = attributes.join
  end

  def generate
    Digest::SHA1.hexdigest(@data)
  end
end
