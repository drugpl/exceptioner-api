require 'exceptioner_api/models'

module Exceptioner::Api::Models
  class Notice < Base
    belongs_to :error,   :class_name => "Exceptioner::Api::Models::Error"

    attributes :message
    indexes    :error_id

    validates_presence_of :message, :error
  end
end
