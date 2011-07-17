require 'exceptioner_api/models'

module Exceptioner::Api::Models
  class Project < Base
    attributes :name, :api_key

    validates_uniqueness_of :api_key
    validates_presence_of   :api_key, :name

    before_validation(:on => :create) do
      generate_api_key!
    end

    def generate_api_key!
      self.api_key = SecureRandom.hex
      save unless new_record?
    end
  end
end
