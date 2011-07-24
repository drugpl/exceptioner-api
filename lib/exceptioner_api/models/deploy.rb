require 'exceptioner_api/models'

module Exceptioner::Api::Models
  class Deploy
    include Mongoid::Document
    include Mongoid::Timestamps

    field :enviroment, type: String
    field :repository, type: String
    field :revision,   type: String
    field :author,     type: String

    belongs_to  :project, class_name: "Exceptioner::Api::Models::Project"

    validates_presence_of :repository, :revision, :environment, :author
  end
end
