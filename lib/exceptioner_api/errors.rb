require 'exceptioner_api/standard_http_errors'

module Exceptioner
  module Api
    class MissingApiKeyError < BadRequestError ; end
    class InvalidApiKeyError < UnauthorizedError ; end
    class InvalidJsonError < BadRequestError ; end

    class ValidationFailedError < UnprocessableEntityError
      def message
        "Validation failed"
      end
    end
  end
end
