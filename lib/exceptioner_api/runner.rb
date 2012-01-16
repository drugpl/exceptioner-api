ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
require 'exceptioner_api/application'

app = Exceptioner::Api::Application.new
app.run
