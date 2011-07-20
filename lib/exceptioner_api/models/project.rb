require 'exceptioner_api/models'

module Exceptioner::Api::Models
  class Project < Base
    has_many :submitted_errors, :class_name => "Exceptioner::Api::Models::Error"

    attributes :name, :api_key
    indexes    :name, :api_key

    validates_uniqueness_of :api_key
    validates_presence_of   :api_key, :name

    before_validation :generate_api_key!, :unless => :api_key

    def generate_api_key!
      self.api_key = SecureRandom.hex
      save unless new_record?
    end
  end
end
