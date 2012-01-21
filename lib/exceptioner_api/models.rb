require 'mongoid'

class Error
  include Mongoid::Document

  field :exception, type: String
  field :backtrace, type: String

  has_many :notices
end

class Notice
  include Mongoid::Document

  field :message,  type: String

  belongs_to :error
end

