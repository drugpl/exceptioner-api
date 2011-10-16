module Exceptioner
  module Api
    class Error < StandardError
      attr_accessor :code

      def initialize(status_code, message)
        super(message)
        @code = status_code
      end
    end
  end
end
