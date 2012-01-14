require 'rest_client'
require 'active_support/concern'
require 'active_support/core_ext/string'

module RspecApiDsl
  # This module is almost exact copy from this dsl:
  # https://raw.github.com/zipmark/rspec_api_documentation/master/lib/rspec_api_documentation/dsl.rb
  #
  # I didn't quike like Rails dependency and all that stuff
  # so I made few tweaks and attached RestClient.

  extend ActiveSupport::Concern

  module ClassMethods
    def self.define_action(method)
      define_method method do |*args, &block|
      options = if args.last.is_a?(Hash) then args.pop else {} end
      options[:method] = method
      options[:path] = args.first
      args.push(options)
      args[0] = "#{method.to_s.upcase} #{args[0]}"
      context(*args, &block)
      end
    end

    define_action :get
    define_action :head
    define_action :post
    define_action :put
    define_action :patch
    define_action :delete

    def parameter(name, description, options = {})
      parameters.push(options.merge(:name => name.to_s, :description => description))
    end

    def required_parameters(*names)
      names.each do |name|
        param = parameters.find { |param| param[:name] == name.to_s }
        raise "Undefined parameters can not be required." unless param
        param[:required] = true
      end
    end

    def scope_parameters(scope, keys)
      return unless metadata[:parameters]

      if keys == :all
        keys = parameter_keys.map(&:to_s)
      else
        keys = keys.map(&:to_s)
      end

      keys.each do |key|
        param = parameters.detect { |param| param[:name] == key }
        param[:scope] = scope if param
      end
    end

    def example_request(description, params = {}, &block)
      example(description) do
        do_request(params)
        instance_eval &block if block_given?
      end
    end

    private
    def parameters
      metadata[:parameters] ||= []
      if superclass_metadata && metadata[:parameters].equal?(superclass_metadata[:parameters])
        metadata[:parameters] = Marshal.load(Marshal.dump(superclass_metadata[:parameters]))
      end
      metadata[:parameters]
    end

    def parameter_keys
      parameters.map { |param| param[:name] }
    end
  end

  module InstanceMethods
    def do_request(extra_params = {})
      @extra_params = extra_params
      params_or_body = nil
      path_or_query = path

      if method == :get && !query_string.blank?
        path_or_query = path + "?#{query_string}"
      else
        params_or_body = respond_to?(:raw_post) ? raw_post : params
      end

      begin
        @last_response = client.send(method, path_or_query, params_or_body)
      rescue => e
        @last_response = e.response
      end
    end

    def query_string
      query = params.to_a.map do |param|
        param.map! { |a| CGI.escape(a.to_s) }
        param.join("=")
      end
      query.join("&")
    end

    def params
      return unless example.metadata[:parameters]
      parameters = example.metadata[:parameters].inject({}) do |hash, param|
        set_param(hash, param)
      end
      parameters.merge!(extra_params)
      parameters
    end

    def method
      example.metadata[:method]
    end

    def in_path?(param)
      path_params.include?(param)
    end

    def path_params
      example.metadata[:path].scan(/:(\w+)/).flatten
    end

    def path
      matched = example.metadata[:path].gsub(/:(\w+)/) do |match|
        if respond_to?($1)
          send($1)
        else
          match
        end
      end
      File.join(ENV['TEST_URL'], matched)
    end

    def explanation(text)
      example.metadata[:explanation] = text
    end

    def status
      last_response.code
    end

    def headers
      last_response.headers
    end

    def response_body
      last_response.body
    end

    def extra_params
      return {} if @extra_params.nil?
      @extra_params.inject({}) do |h, (k, v)|
        h[k.to_s] = v
      h
      end
    end

    def set_param(hash, param)
      key = param[:name]
      return hash if !respond_to?(key) || in_path?(key)

      if param[:scope]
        hash[param[:scope].to_s] ||= {}
        hash[param[:scope].to_s][key] = send(key)
      else
        hash[key] = send(key)
      end

      hash
    end

    def client
      RestClient
    end

    def last_response
      @last_response
    end
  end
end

def self.resource(*args, &block)
  options = if args.last.is_a?(Hash) then args.pop else {} end
  options[:api_dsl] = true
  options[:resource_name] = args.first
  options[:document] = true
  args.push(options)
  describe(*args, &block)
end

RSpec.configuration.include RspecApiDsl, :api_dsl => true
