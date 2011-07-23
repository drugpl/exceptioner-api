module Exceptioner
  module Api
    class ErrorHandler
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = begin
          @app.call(env)
        rescue ::Exceptioner::Api::Error => exc
          [exc.status_code, json_headers, {:message => exc.to_s}.to_json]
        rescue ::Mongoid::Errors::Validations => exc
          [422, json_headers, {:message => "Validation failed"}.to_json]
        rescue ::Mongoid::Errors::DocumentNotFound
          [404, json_headers, {:message => "Not found"}.to_json]
        #rescue ::Exception
        #  [500, json_headers, {:message => "Internal Server Error"}.to_json]
        end
        [status, headers, body]
      end

      protected
      def json_headers
        {'Content-Type' => 'application/json'}
      end
    end
  end
end
