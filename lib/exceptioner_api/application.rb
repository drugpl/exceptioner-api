raise LoadError, 'Ruby 1.9.2 required' if RUBY_VERSION < '1.9.2'

require 'bundler'
require 'rabl'
require 'rack/fiber_pool'
require 'sinatra/base'
require 'sinatra/synchrony'
require 'exceptioner_api/standard_http_errors'
require 'exceptioner_api/error_handler'
require 'exceptioner_api/models/project'
require 'exceptioner_api/models/notice'
require 'exceptioner_api/models/error'
require 'exceptioner_api'

module Exceptioner
  module Api
    class Application < Sinatra::Base
      class MissingApiKeyError < BadRequestError ; end
      class InvalidApiKeyError < UnauthorizedError ; end

      register Sinatra::Synchrony
      use ErrorHandler

      Rabl.configure do |config|
        config.include_json_root = false
      end
      Rabl.register!

      Mongoid.configure do |config|
        config.database = Mongo::Connection.new.db("exceptioner")
      end

      set :root,  Exceptioner::Api.root
      set :views, Exceptioner::Api.root.join('views')
      set :show_exceptions, false
      set :raise_errors,    true

      helpers do
        def rabl(name, *args) render(:rabl, name.to_sym, *args) end

        def payload
          @payload ||= JSON.parse(request.body.read.to_s).with_indifferent_access
        end
      end

      before do
        check_api_key!
        validate_api_key!
      end

      post "/v1/notices", provides: [:json] do
        error_params = payload.delete(:error) || Hash.new
        error   = @project.submitted_errors.find_or_create_from_params!(error_params)
        @notice = error.notices.create!(payload)
        status 201
        rabl "notices/show"
      end

      get "/v1/errors/:error_id/notices" do # , :provides => [:json] do # XXX: why?
        error    = @project.submitted_errors.find(params[:error_id])
        @notices = error.notices
        rabl "notices/index"
      end

      get "/v1/errors/:error_id/notices/:id" do
        error    = @project.submitted_errors.find(params[:error_id])
        @notice  = error.notices.find(params[:id])
        rabl "notices/show"
      end

      get "/v1/errors/:id" do
        @error = @project.submitted_errors.find(params[:id])
        rabl "errors/show"
      end

      get "/v1/errors" do
        # XXX: resolved finder
        @errors = @project.submitted_errors
        rabl "errors/index"
      end

      patch "/v1/errors/:id" do
        @errors = @project.submitted_errors.find(params.delete(:id))
        @error.update_attributes(payload)
        rabl "errors/show"
      end

      protected
      def api_key
        # XXX: HTTP_API_KEY - why does it differ between post/get?
        request.env["HTTP_API_KEY"] || params["HTTP_API_KEY"] || params["api_key"]
      end

      def check_api_key!
        raise MissingApiKeyError if api_key.to_s.empty?
      end

      def validate_api_key!
        @project = Models::Project.where(api_key: api_key).first
        raise InvalidApiKeyError unless @project
      end

      def dump_errors!(boom)
        super unless boom.is_a?(::Exceptioner::Api::Error)
      end
    end
  end
end
