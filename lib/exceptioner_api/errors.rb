require 'exceptioner_api/standard_http_errors'

module Exceptioner
  module Api
    class MissingApiKeyError < BadRequestError  ; end
    class InvalidApiKeyError < UnauthorizedError; end
  end
end
