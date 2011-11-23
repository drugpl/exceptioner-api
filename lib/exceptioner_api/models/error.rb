require 'exceptioner_api/models'
require 'exceptioner_api/fingerprint_generator'

module Exceptioner::API::Models
  class Error
    FINGERPRINT_ATTRIBUTES = %w(exception backtrace parameters)
  end
end
