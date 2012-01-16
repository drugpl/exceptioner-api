require 'mongoid'

class Error
  include Mongoid::Document

  field :exception, type: String
  field :backtrace, type: String

  embeds_many :notices
end

class Notice
  include Mongoid::Document

  field :message,  type: String
  field :error_id, type: String

  embedded_in :error
end

