require 'active_support/core_ext/module/delegation'
require 'exceptioner_api/models'
require 'exceptioner_api/resources'
require 'exceptioner_api'

Mongoid.load! Exceptioner::Api.root.join("config/mongoid.yml")

module Exceptioner
  module Api
    class Application
      attr_reader :webmachine
      delegate :adapter, :run, to: :webmachine

      def initialize(options = {})
        options[:port]    ||= 8080
        options[:adapter] ||= :WEBrick

        @webmachine = Webmachine::Application.new do |app|
          app.configure do |config|
            config.port    = options[:port]
            config.adapter = options[:adapter]
          end

          app.add_route ['notices', :id], NoticeResource
          app.add_route ['notices'], NoticeCollectionResource

          app.add_route ['errors', :id], ErrorResource
          app.add_route ['errors'], ErrorCollectionResource
        end
      end
    end
  end
end

