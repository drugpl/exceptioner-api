require 'bundler/setup'
require 'ostruct'

ENV['TEST_URL'] ||= 'http://localhost:1234'
require_relative "support/rspec_api_dsl"
