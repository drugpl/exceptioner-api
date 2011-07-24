require 'exceptioner_api/models'
require 'exceptioner_api/utils'

module Exceptioner::Api::Models
  class Error
    include Mongoid::Document
    include Mongoid::Timestamps

    FINGERPRINT_ATTRIBUTES = %w(exception backtrace parameters)

    field :exception,   type: String
    field :backtrace,   type: Array
    field :parameters,  type: Hash
    field :session,     type: Hash
    field :environment, type: Hash
    field :fingerprint, type: String
    field :file,        type: String
    field :mode,        type: String
    field :resolved,    type: Boolean, default: false

    attr_protected :fingerprint

    belongs_to  :project, class_name: "Exceptioner::Api::Models::Project"
    embeds_many :notices, class_name: "Exceptioner::Api::Models::Notice"

    validates_presence_of  :exception, :fingerprint, :project
    validates_inclusion_of :resolved, in: [true, false]

    before_validation :generate_fingerprint!, unless: :fingerprint

    protected
    def generate_fingerprint!
      values = self.attributes.values_at(*FINGERPRINT_ATTRIBUTES)
      self.fingerprint = Exceptioner::Api::Utils::FingerprintGenerator.new(values).generate
    end
  end
end
