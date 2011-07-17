module Exceptioner
  module Api
    class Error < StandardError
      attr_accessor :status_code

      def initialize(status_code, message)
        super(message)
        @status_code = status_code
      end
    end
  end
end
