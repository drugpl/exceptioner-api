require 'exceptioner_api/models'

module Exceptioner::API::Models
  class Project
    attr_reader :api_key

    def generate_api_key!
      @api_key = SecureRandom.hex
    end
  end
end
