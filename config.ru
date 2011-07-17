$: << File.expand_path(File.join(File.dirname(__FILE__), "lib"))

require 'exceptioner_api/application'
run Exceptioner::Api::Application
