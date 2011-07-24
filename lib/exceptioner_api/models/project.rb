require 'exceptioner_api/models'
require 'exceptioner_api/utils'

module Exceptioner::Api::Models
  class Project
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,    type: String
    field :api_key, type: String

    has_many :deploys, class_name: "Exceptioner::Api::Models::Deploy"
    has_many :submitted_errors, class_name: "Exceptioner::Api::Models::Error" do
      def find_or_create_from_params!(params = {})
        values = params.stringify_keys.values_at(*Error::FINGERPRINT_ATTRIBUTES)
        where(fingerprint: Exceptioner::Api::Utils::FingerprintGenerator.new(values).generate).first || create!(params)
      end
    end

    validates_uniqueness_of :api_key
    validates_presence_of   :api_key, :name

    before_validation :generate_api_key!, unless: :api_key

    def generate_api_key!
      self.api_key = SecureRandom.hex
      save unless new_record?
    end
  end
end
