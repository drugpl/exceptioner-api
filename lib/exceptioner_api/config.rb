require 'exceptioner_api'

Dir["#{Exceptioner::Api.root}/config/**/*.rb"].each { |f| require f }
