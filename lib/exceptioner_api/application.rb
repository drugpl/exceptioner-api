raise LoadError, 'Ruby 1.9.2 required' if RUBY_VERSION < '1.9.2'

require 'bundler'
require 'sinatra/base'
require 'sinatra/synchrony'
require 'exceptioner_api/config'
require 'exceptioner_api/models'
require 'exceptioner_api/errors'

module Exceptioner
  module Api
    class Application < Sinatra::Base
      register Sinatra::Synchrony

      set :root,  Exceptioner::Api.root
      set :views, Exceptioner::Api.root.join('views')

      error 400..500 do
        exc        = env['sinatra.error']
        code, body = case exc
                     when ::Exceptioner::Api::ValidationFailedError
                       [exc.code, exc.message]
                       # XXX: change here
                     when ::Exceptioner::Api::Error
                       [exc.code, exc.message]
                     else
                       [500, "Internal server error"]
                     end
        status(code)
        {message: body}.to_json
      end

      error 404 do
        {message: "Not found"}.to_json
      end

      helpers do
        def rabl(name, *args)
          render(:rabl, name.to_sym, *args)
        end

        def payload
          begin
            @payload ||= JSON.parse(request.body.read.to_s).with_indifferent_access
          rescue JSON::ParserError
            raise InvalidJsonError, "Problems parsing JSON"
          end
        end
      end

      before do
        check_api_key!
        validate_api_key!
      end

      post "/v1/notices", provides: [:json] do
        error_params = payload.delete(:error) || Hash.new
        begin
          error   = @project.submitted_errors.find_or_create_from_params!(error_params)
          @notice = error.notices.create!(payload)
          status 201
          rabl "notices/show"
        rescue ::Mongoid::Errors::Validations
          raise ValidationFailedError
        end
      end

      get "/v1/errors/:error_id/notices" do
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
        @errors = case params[:resolved]
                  when false, nil
                    @project.submitted_errors.unresolved
                  else
                    @project.submitted_errors
                  end
        rabl "errors/index"
      end

      error_update = Proc.new do |project, params, payload|
        @error = project.submitted_errors.find(params[:id])
        begin
          @error.update_attributes(payload)
          @error
        rescue ::Mongoid::Errors::Validations
          raise ValidationFailedError
        end
      end

      patch "/v1/errors/:id", provides: [:json] do
        @error = error_update.call(@project, params, payload)
        rabl "errors/show"
      end

      # XXX: compatibility
      post  "/v1/errors/:id", provides: [:json] do
        @error = error_update.call(@project, params, payload)
        rabl "errors/show"
      end

      post "/v1/deploys", provides: [:json] do
        begin
          @deploy = @project.deploys.create!(payload)
          status 201
          rabl "deploys/show"
        rescue ::Mongoid::Errors::Validations
          raise ValidationFailedError
        end
      end

      get "/v1/deploys" do
        @deploys = @project.deploys
        rabl "deploys/index"
      end

      get "/v1/deploys/:id" do
        @deploy = @project.deploys.find(params[:id])
        rabl "deploys/show"
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
