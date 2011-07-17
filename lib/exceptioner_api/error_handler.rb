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
        rescue ::Exception
          [404, json_headers, {:message => "Internal Server Error"}]
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
