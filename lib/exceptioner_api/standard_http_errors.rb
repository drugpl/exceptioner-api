require 'exceptioner_api/error'
require 'exceptioner_api/http_status_codes'

module Exceptioner
  module Api
    HTTP_ERROR_CODES = HTTP_STATUS_CODES.select { |code,msg| code >= 400 && code <= 599 }

    HTTP_ERROR_CODES.each do |code, msg|
      klass_name = "#{msg.gsub(/\W+/, '')}Error".gsub(/ErrorError$/, "Error")
      klass = Class.new(Exceptioner::Api::Error)
      klass.class_eval(%Q{
        def initialize(message='#{msg}')
          super('#{code}', message)
        end }, __FILE__, __LINE__)

      Exceptioner::Api.const_set(klass_name, klass)
    end
  end
end
