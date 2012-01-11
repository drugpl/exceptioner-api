raise LoadError, 'Ruby 1.9.2 required' if RUBY_VERSION < '1.9.2'

require 'bundler'
require 'grape'
require 'sinatra/base'
require 'sinatra/synchrony'
require 'exceptioner_api/config'
require 'exceptioner_api/models'
require 'exceptioner_api/errors'

module Exceptioner
  module Api
    class Application < Grape::API

      rescue_from :all do |exc|
        code, body = case exc
                     when ::Exceptioner::Api::ValidationFailedError
                       [exc.code, exc.message]
                     when ::Exceptioner::Api::Error
                       [exc.code, exc.message]
                     else
                       [500, "Internal server error"]
                     end
        
        rack_response({ message: body }.to_json, code)
      end
     
      helpers do
        def payload
          begin
            @payload ||= JSON.parse(request.body.read.to_s).with_indifferent_access
          rescue JSON::ParserError
            raise InvalidJsonError, "Problems parsing JSON"
          end
        end

        def check_api_key!
          raise MissingApiKeyError if api_key.to_s.empty?
        end

        def validate_api_key!
          @project = Models::Project.where(api_key: api_key).first
          raise InvalidApiKeyError unless @project
        end

        def api_key
          # XXX: HTTP_API_KEY - why does it differ between post/get?
          request.env["HTTP_API_KEY"] || params["HTTP_API_KEY"] || params["api_key"]
        end

        def error_update 
          Proc.new do |project, params, payload|
            @error = project.submitted_errors.find(params[:id])
            begin
              @error.update_attributes(payload)
              @error
            rescue ::Mongoid::Errors::Validations
              raise ValidationFailedError
            end
          end
        end
      end

      before do
        check_api_key!
        validate_api_key!
      end

      version 'v1', using: :path, format: :json

      post "/notices", rabl: "notices/show" do
        error_params = payload.delete(:error) || Hash.new
        begin
          error   = @project.submitted_errors.find_or_create_from_params!(error_params)
          @notice = error.notices.create!(payload)
          status 201
        rescue ::Mongoid::Errors::Validations
          raise ValidationFailedError
        end
      end

      get "/errors/:error_id/notices", rabl: "notices/index" do
        error    = @project.submitted_errors.find(params[:error_id])
        @notices = error.notices
      end

      get "/errors/:error_id/notices/:id", rabl: "notices/show" do
        error    = @project.submitted_errors.find(params[:error_id])
        @notice  = error.notices.find(params[:id])
      end

      get "/errors/:id", rabl: "errors/show" do
        @error = @project.submitted_errors.find(params[:id])
      end

      get "/errors", rabl: "errors/index" do
        @errors = case params[:resolved]
                  when false, nil
                    @project.submitted_errors.unresolved
                  else
                    @project.submitted_errors
                  end
      end


      patch "/errors/:id", rabl: "errors/show" do
        @error = error_update.call(@project, params, payload)
      end

      # XXX: compatibility
      post  "/errors/:id", rabl: "errors/show" do
        @error = error_update.call(@project, params, payload)
      end

      post "/deploys", rabl: "deploys/show.rabl" do
        begin
          @deploy = @project.deploys.create!(payload)
          status 201
        rescue ::Mongoid::Errors::Validations
          raise ValidationFailedError
        end
      end

      get "/deploys", rabl: "deploys/index" do
        @deploys = @project.deploys
      end

      get "/deploys/:id", rabl: "deploys/show" do
        @deploy = @project.deploys.find(params[:id])
      end

      protected

      def dump_errors!(boom)
        super unless boom.is_a?(::Exceptioner::Api::Error)
      end
    end
  end
end
