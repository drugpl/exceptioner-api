raise LoadError, 'Ruby 1.9.2 required' if RUBY_VERSION < '1.9.2'

require 'bundler'
require 'rabl'
require 'rack/fiber_pool'
require 'sinatra/base'
require 'sinatra/synchrony'
require 'exceptioner_api/standard_http_errors'
require 'exceptioner_api/error_handler'
require 'exceptioner_api/models/project'
require 'exceptioner_api'

module Exceptioner
  module Api
    class Application < Sinatra::Base
      class MissingApiKeyError < BadRequestError ; end
      class InvalidApiKeyError < UnauthorizedError ; end

      register Sinatra::Synchrony
      use ErrorHandler

      Rabl.register!

      set :root,  Exceptioner::Api.root
      set :views, Exceptioner::Api.root.join('views')
      set :show_exceptions, false
      set :raise_errors,    true

      helpers do
        def rabl(name, *args) render(:rabl, name.to_sym, *args) end
      end

      before do
        check_api_key!
        validate_api_key!
      end

      protected

      def api_key
        request.env["HTTP_API_KEY"] || params["api_key"]
      end

      def check_api_key!
        raise MissingApiKeyError if api_key.to_s.empty?
      end

      def validate_api_key!
        @project = Models::Project.find_by_api_key(api_key)
        raise InvalidApiKeyError unless @project
      end

      def dump_errors!(boom)
        super unless boom.is_a?(::Exceptioner::Api::Error)
      end
    end
  end
end
