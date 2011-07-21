require 'exceptioner_api/models'
require 'fingerprint_generator'

module Exceptioner::Api::Models
  class Error < Base
    FINGERPRINT_ATTRIBUTES = %w(exception backtrace parameters)

    belongs_to :project, :class_name => "Exceptioner::Api::Models::Project"
    has_many   :notices, :class_name => "Exceptioner::Api::Models::Notice", :foreign_key => "error_id"

    attributes :exception, :fingerprint, :backtrace, :environment, :parameters, :session, :backtrace, :resolved
    indexes    :fingerprint, :resolved, :project_id

    validates_presence_of  :exception, :fingerprint, :project
    validates_inclusion_of :resolved, :in => [true, false]

    before_validation :generate_fingerprint!, :unless => :fingerprint

    def notices_count
      notices.size
    end

    def most_recent_notice_at
      notices.last # order(:created_at).last.created_at
    end

    def self.find_or_create_from_params!(params = {})
      fingerprint = FingerprintGenerator.generate_fingerprint(params.stringify_keys.values_at(*FINGERPRINT_ATTRIBUTES)) rescue nil
      self.find_by_fingerprint(fingerprint) || self.create!(params)
    end

    protected
    def generate_fingerprint!
      self.fingerprint = FingerprintGenerator.generate_fingerprint(self.attributes.values_at(*FINGERPRINT_ATTRIBUTES))
    end
  end
end
