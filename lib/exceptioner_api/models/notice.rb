require 'exceptioner_api/models'

module Exceptioner::Api::Models
  class Notice
    include Mongoid::Document
    include Mongoid::Timestamps

    embedded_in :error, class_name: "Exceptioner::Api::Models::Error"

    field :message, type: String

    validates_presence_of :message, :error
  end
end
