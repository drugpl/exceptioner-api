require 'exceptioner_api/models'

module Exceptioner::Api::Models
  class Notice < Base
    belongs_to :project, :class_name => "Exceptioner::Api::Models::Project"
    belongs_to :error,   :class_name => "Exceptioner::Api::Models::Error"

    attributes :message

    validates_presence_of :message
  end
end
